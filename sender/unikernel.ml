open Lwt.Infix

module Make (Time : Mirage_time.S) (Stack : Tcpip.Stack.V4V6) = struct
  let start () stack =
    let ip = Key_gen.ip () in
    let ip = match Ipaddr.of_string ip with
      | Ok ip -> ip
      | Error _ -> failwith "Cannot parse ip address"
    in
    let port = Key_gen.port () in
    let tcp = Stack.tcp stack in
    let rec loop () =
      Stack.TCP.create_connection tcp (ip, port) >>= begin function
      | Error e ->
          Logs.warn (fun f -> f "Error: %a" Stack.TCP.pp_error e);
          Lwt.return_unit
      | Ok flow ->
          Stack.TCP.close flow
      end >>= fun () ->
      Time.sleep_ns (Duration.of_min 5) >>= fun () ->
      loop ()
    in
    loop ()
end
