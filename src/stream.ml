type 'kind t = 'kind C.Types.Stream.stream Handle.t

let allocate kind =
  Handle.allocate ~reference_count:C.Types.Stream.reference_count kind

let coerce : type kind. kind t -> [ `Base ] t =
  Obj.magic

let shutdown_trampoline =
  C.Functions.Stream.Shutdown_request.get_trampoline ()

let shutdown stream callback =
  let callback = Error.catch_exceptions callback in
  let request = Request.allocate C.Types.Stream.Shutdown_request.t in
  Request.set_callback request callback;
  let immediate_result =
    C.Functions.Stream.shutdown request (coerce stream) shutdown_trampoline in
  if immediate_result < Error.success then begin
    Request.release request;
    callback immediate_result
  end

let connection_trampoline =
  C.Functions.Stream.get_connection_trampoline ()

let listen ?(backlog = C.Types.Stream.somaxconn) server callback =
  let callback = Error.catch_exceptions callback in
  Handle.set_reference
    ~index:C.Types.Stream.connection_callback_index server callback;
  let immediate_result =
    C.Functions.Stream.listen (coerce server) backlog connection_trampoline in
  if immediate_result < Error.success then
    callback immediate_result

let accept ~server ~client =
  C.Functions.Stream.accept (coerce server) (coerce client)

let alloc_trampoline =
  C.Functions.Handle.get_alloc_trampoline ()

let read_trampoline =
  C.Functions.Stream.get_read_trampoline ()

(* DOC Document memory management of this function. *)
let read_start ?(allocate = Bigstring.create) stream callback =
  let last_allocated_buffer = ref None in

  let callback = Error.catch_exceptions callback in
  Handle.set_reference stream begin fun (nread_or_error : Error.t) ->
    let result =
      if (nread_or_error :> int) > 0 then begin
        let length = (nread_or_error :> int) in
        let buffer =
          match !last_allocated_buffer with
          | Some buffer -> buffer
          | None -> assert false
        in
        last_allocated_buffer := None;
        Result.Ok (Bigstring.sub buffer ~offset:0 ~length)
      end
      else begin
        last_allocated_buffer := None;
        Result.Error nread_or_error
      end
    in
    callback result
  end;

  Handle.set_reference stream ~index:C.Types.Stream.allocate_callback_index
      begin fun suggested_size ->

    let buffer = allocate suggested_size in
    last_allocated_buffer := Some buffer;
    buffer
  end;

  let immediate_result =
    C.Functions.Stream.read_start
      (coerce stream) alloc_trampoline read_trampoline
  in
  if immediate_result < Error.success then
    callback (Error immediate_result)

let read_stop stream =
  C.Functions.Stream.read_stop (coerce stream)

let write_trampoline =
  C.Functions.Stream.Write_request.get_trampoline ()

(* DOC send_handle must remain open during the operation. *)
let write ?send_handle stream buffers callback =
  let count = List.length buffers in
  let bytes = Bigstring.List.total_size buffers in
  let iovecs = Helpers.Buf.bigstrings_to_iovecs buffers count in

  let request = Request.allocate C.Types.Stream.Write_request.t in

  let wrapped_callback result =
    ignore (Sys.opaque_identity buffers);
    ignore (Sys.opaque_identity iovecs);
    let bytes_unwritten =
      C.Functions.Stream.get_write_queue_size (coerce stream)
      |> Unsigned.Size_t.to_int
    in
    callback result (bytes - bytes_unwritten)
  in
  let wrapped_callback = Error.catch_exceptions wrapped_callback in
  Request.set_callback request wrapped_callback;

  let send_handle =
    match send_handle with
    | None -> Ctypes.from_voidp C.Types.Stream.t Ctypes.null
    | Some handle -> coerce handle
  in

  let immediate_result =
    C.Functions.Stream.write2
      request
      (coerce stream)
      (Ctypes.CArray.start iovecs)
      (Unsigned.UInt.of_int count)
      send_handle
      write_trampoline
  in

  if immediate_result < Error.success then begin
    Request.release request;
    Error.catch_exceptions (fun () -> callback immediate_result 0) ()
  end

let try_write stream buffers =
  let count = List.length buffers in
  let iovecs = Helpers.Buf.bigstrings_to_iovecs buffers count in

  let result =
    C.Functions.Stream.try_write
      (coerce stream)
      (Ctypes.CArray.start iovecs)
      (Unsigned.UInt.of_int count)
  in

  ignore (Sys.opaque_identity buffers);
  ignore (Sys.opaque_identity iovecs);

  Error.to_result (result :> int) result

let is_readable stream =
  C.Functions.Stream.is_readable (coerce stream)

let is_writable stream =
  C.Functions.Stream.is_writable (coerce stream)

let set_blocking stream blocking =
  C.Functions.Stream.set_blocking (coerce stream) blocking

module Connect_request =
struct
  type t = [ `Connect ] Request.t

  let make () =
    Request.allocate C.Types.Stream.Connect_request.t

  let trampoline =
    C.Functions.Stream.Connect_request.get_trampoline ()
end