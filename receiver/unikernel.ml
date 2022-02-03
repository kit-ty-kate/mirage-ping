open Lwt.Infix

module Make (Stack : Tcpip.Stack.V4) = struct
  let start stack =
    let port = Key_gen.port () in
    Stack.listen_tcpv4 stack ~port begin fun flow ->
      let ip, port = Stack.TCPV4.dst flow in
      let ip = Ipaddr.V4.to_string ip in
      Stack.TCPV4.read flow >>= begin function
      | Ok `Eof ->
          Logs.info (fun f -> f "[%s:%d] Connexion closed" ip port);
          Lwt.return_unit
      | Error e ->
          Logs.warn (fun f -> f "[%s:%d] Error: %a" ip port Stack.TCPV4.pp_error e);
          Lwt.return_unit
      | Ok (`Data data) ->
          Logs.info (fun f -> f "[%s:%d] %d bytes reveived" ip port (Cstruct.len data));
          Lwt.return_unit
      end >>= fun () ->
      Stack.TCPV4.close flow
    end;
    Stack.listen stack
end
