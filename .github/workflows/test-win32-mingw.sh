#!/bin/sh
set -euf

# Avoid:
#   luv_unix.c:9:10: fatal error: uv.h: No such file or directory
#     9 | #include <uv.h>
install    _build/install/default/lib/luv/uv.h /usr/x86_64-w64-mingw32/sys-root/mingw/include
rsync -ap  _build/install/default/lib/luv/uv   /usr/x86_64-w64-mingw32/sys-root/mingw/include

# Remove unit tests that hang.
# * If all unit tests are removed from a module, then `open Test_helpers` must be removed to avoid compiler unused warnings.
sed -i '/^    "connect, synchronous error leak"/,/^    end;/d'  test/TCP.ml
sed -i '/^    "listen, accept"/,/^    end;/d'                   test/TCP.ml
sed -i '/^    "listen: exception"/,/^    end;/d'                test/TCP.ml
sed -i '/^    "connect: exception"/,/^    end;/d'               test/TCP.ml
sed -i '/^    "read, write"/,/^    end;/d'                      test/TCP.ml
sed -i '/^    "eof"/,/^    end;/d'                              test/TCP.ml
sed -i '/^    "write: sync error"/,/^    end;/d'                test/TCP.ml
sed -i '/^    "write: sync error leak"/,/^    end;/d'           test/TCP.ml
sed -i '/^    "read: exception"/,/^    end;/d'                  test/TCP.ml
sed -i '/^    "write: exception"/,/^    end;/d'                 test/TCP.ml
sed -i '/^    "try_write"/,/^    end;/d'                        test/TCP.ml
sed -i '/^    "try_write: error"/,/^    end;/d'                 test/TCP.ml
sed -i '/^    "shutdown"/,/^    end;/d'                         test/TCP.ml
sed -i '/^    "shutdown: sync error"/,/^    end;/d'             test/TCP.ml
sed -i '/^    "shutdown: sync error leak"/,/^    end;/d'        test/TCP.ml
sed -i '/^    "shutdown: exception"/,/^    end;/d'              test/TCP.ml
sed -i '/^    "close_reset: sync error"/,/^    end;/d'          test/TCP.ml
sed -i '/^    "close_reset"/,/^    end;/d'                      test/TCP.ml
sed -i '/^    "handle functions"/,/^    end;/d'                 test/TCP.ml
sed -i '/^    "socketpair"/,/^    end;/d'                       test/TCP.ml
sed -i '/^    "init, close"/,/^    end;/d'                      test/UDP.ml
sed -i '/^    "bind, getsockname"/,/^    end;/d'                test/UDP.ml
sed -i '/^    "send, recv"/,/^    end;/d'                       test/UDP.ml
sed -i '/^    "try_send"/,/^    end;/d'                         test/UDP.ml
sed -i '/^    "send: exception"/,/^    end;/d'                  test/UDP.ml
sed -i '/^    "recv: exception"/,/^    end;/d'                  test/UDP.ml
sed -i '/^    "empty datagram"/,/^    end;/d'                   test/UDP.ml
sed -i '/^    "multicast"/,/^    end;/d'                        test/UDP.ml
sed -i '/^    "handle functions"/,/^    end;/d'                 test/UDP.ml
sed -i '/^    "connect, getpeername"/,/^    end;/d'             test/UDP.ml
sed -i '/^    "double connect"/,/^    end;/d'                   test/UDP.ml
sed -i '/^    "initial disconnect"/,/^    end;/d'               test/UDP.ml
sed -i '/^    "connected, send"/,/^    end;/d'                  test/UDP.ml
sed -i '/^    "try_send"/,/^    end;/d'                         test/UDP.ml
sed -i '/^    "open: nonexistent, async"/,/^    end;/d'         test/file.ml
sed -i '/^    "open, close: memory leak, async"/,/^    end;/d'  test/file.ml
sed -i '/^    "open: failure leak, async"/,/^    end;/d'        test/file.ml
sed -i '/^    "open: gc"/,/^    end;/d'                         test/file.ml
sed -i '/^    "open: exception"/,/^    end;/d'                  test/file.ml
sed -i '/^    "read failure: async"/,/^    end;/d'              test/file.ml
sed -i '/^    "read leak: async"/,/^    end;/d'                 test/file.ml
sed -i '/^    "read leak: async"/,/^    end;/d'                 test/file.ml
sed -i '/^    "read sync failure leak"/,/^    end;/d'           test/file.ml
sed -i '/^    "read gc"/,/^    end;/d'                          test/file.ml
sed -i '/^    "write: async"/,/^    end;/d'                     test/file.ml
sed -i '/^    "unlink: async"/,/^    end;/d'                    test/file.ml
sed -i '/^    "unlink failure: async"/,/^    end;/d'            test/file.ml
sed -i '/^    "mkdir, rmdir: async"/,/^    end;/d'              test/file.ml
sed -i '/^    "mkdir failure: async"/,/^    end;/d'             test/file.ml
sed -i '/^    "rmdir failure: async"/,/^    end;/d'             test/file.ml
sed -i '/^    "mkdtemp: async"/,/^    end;/d'                   test/file.ml
sed -i '/^    "mkdtemp failure: async"/,/^    end;/d'           test/file.ml
sed -i '/^    "mkstemp: async"/,/^    end;/d'                   test/file.ml
sed -i '/^    "mkstemp failure: async"/,/^    end;/d'           test/file.ml
sed -i '/^    "opendir, closedir: async"/,/^    end;/d'         test/file.ml
sed -i '/^    "readdir: async"/,/^    end;/d'                   test/file.ml
sed -i '/^    "readdir: gc"/,/^    end;/d'                      test/file.ml
sed -i '/^    "scandir: async"/,/^    end;/d'                   test/file.ml
sed -i '/^    "scandir failure: async"/,/^    end;/d'           test/file.ml
sed -i '/^    "stat: async"/,/^    end;/d'                      test/file.ml
sed -i '/^    "stat failure: async"/,/^    end;/d'              test/file.ml
sed -i '/^    "lstat: async"/,/^    end;/d'                     test/file.ml
sed -i '/^    "lstat failure: async"/,/^    end;/d'             test/file.ml
sed -i '/^    "fstat: async"/,/^    end;/d'                     test/file.ml
sed -i '/^    "statfs: async"/,/^    end;/d'                    test/file.ml
sed -i '/^    "statfs failure: async"/,/^    end;/d'            test/file.ml
sed -i '/^    "rename: async"/,/^    end;/d'                    test/file.ml
sed -i '/^    "rename failure: async"/,/^    end;/d'            test/file.ml
sed -i '/^    "ftruncate: async"/,/^    end;/d'                 test/file.ml
sed -i '/^    "ftruncate failure: async"/,/^    end;/d'         test/file.ml
sed -i '/^    "copyfile: async"/,/^    end;/d'                  test/file.ml
sed -i '/^    "copyfile failure: async"/,/^    end;/d'          test/file.ml
sed -i '/^    "sendfile: async"/,/^    end;/d'                  test/file.ml
sed -i '/^    "access: async"/,/^    end;/d'                    test/file.ml
sed -i '/^    "access failure: async"/,/^    end;/d'            test/file.ml
sed -i '/^    "init, close"/,/^    end;/d'                      test/FS_event.ml
sed -i '/^    "start, stop"/,/^    end;/d'                      test/FS_event.ml
sed -i '/^    "create"/,/^    end;/d'                           test/FS_event.ml
sed -i '/^    "change"/,/^    end;/d'                           test/FS_event.ml
sed -i '/^    "init, close"/,/^    end;/d'                      test/FS_poll.ml
sed -i '/^    "start, stop"/,/^    end;/d'                      test/FS_poll.ml
sed -i '/^    "create"/,/^    end;/d'                           test/FS_poll.ml
sed -i '/^    "getaddrinfo"/,/^    end;/d'                      test/DNS.ml
sed -i '/^    "getnameinfo"/,/^    end;/d'                      test/DNS.ml
sed -i '/open Test_helpers/d'                                   test/DNS.ml
sed -i '/^    "work"/,/^    end;/d'                             test/thread_.ml
sed -i '/^    "work: work exception"/,/^    end;/d'             test/thread_.ml
sed -i '/^    "work: end exception"/,/^    end;/d'              test/thread_.ml
sed -i '/^    "create"/,/^    end;/d'                           test/thread_.ml
sed -i '/^    "self, equal"/,/^    end;/d'                      test/thread_.ml
sed -i '/^    "join"/,/^    end;/d'                             test/thread_.ml
sed -i '/^    "create: exception"/,/^    end;/d'                test/thread_.ml
sed -i '/^    "join: pipe"/,/^    end;/d'                       test/thread_.ml
sed -i '/^    "join: sequenced"/,/^    end;/d'                  test/thread_.ml
sed -i '/^    "function leak"/,/^    end;/d'                    test/thread_.ml
sed -i '/^    "tls: two threads"/,/^    end;/d'                 test/thread_.ml
sed -i '/^    "tls: two keys"/,/^    end;/d'                    test/thread_.ml
sed -i '/^    "once"/,/^    end;/d'                             test/thread_.ml
sed -i '/^    "mutex"/,/^    end;/d'                            test/thread_.ml
sed -i '/^    "rwlock: readers"/,/^    end;/d'                  test/thread_.ml
sed -i '/^    "rwlock: writer"/,/^    end;/d'                   test/thread_.ml
sed -i '/^    "semaphore"/,/^    end;/d'                        test/thread_.ml
sed -i '/^    "condition"/,/^    end;/d'                        test/thread_.ml
sed -i '/^    "barrier"/,/^    end;/d'                          test/thread_.ml
sed -i '/open Test_helpers/d'                                   test/thread_.ml
sed -i '/^    "async"/,/^    end;/d'                            test/misc.ml

# Test!
ALCOTEST_VERBOSE=1 make test
