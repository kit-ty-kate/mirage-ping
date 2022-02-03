open Lwt.Infix

module Make (Stack : Tcpip.Stack.V4V6) = struct
  let start stack =
    let port = Key_gen.port () in
    Stack.TCP.listen (Stack.tcp stack) ~port begin fun flow ->
      let ip, port = Stack.TCP.dst flow in
      let ip = Ipaddr.to_string ip in
      Stack.TCP.read flow >>= begin function
      | Ok `Eof ->
          Logs.info (fun f -> f "[%s:%d] Connexion closed" ip port);
          Lwt.return_unit
      | Error e ->
          Logs.warn (fun f -> f "[%s:%d] Error: %a" ip port Stack.TCP.pp_error e);
          Lwt.return_unit
      | Ok (`Data data) ->
          Logs.info (fun f -> f "[%s:%d] %d bytes reveived" ip port (Cstruct.length data));
          Lwt.return_unit
      end >>= fun () ->
      Stack.TCP.close flow
    end;
    Stack.listen stack
end
