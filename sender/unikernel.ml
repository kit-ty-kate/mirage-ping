open Lwt.Infix

module Make (Time : Mirage_time_lwt.S) (Stack : Mirage_stack_lwt.V4) = struct
  let start _time stack =
    let ip = Key_gen.ip () in
    let port = Key_gen.port () in
    let tcp = Stack.tcpv4 stack in
    let rec loop () =
      Stack.TCPV4.create_connection tcp (ip, port) >>= begin function
      | Error e ->
          Logs.warn (fun f -> f "Error: %a" Stack.TCPV4.pp_error e);
          Lwt.return_unit
      | Ok flow ->
          Stack.TCPV4.close flow
      end >>= fun () ->
      Time.sleep_ns (Duration.of_hour 1) >>= fun () ->
      loop ()
    in
    loop ()
end
