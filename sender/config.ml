open Mirage

let ip_k =
  let doc = Key.Arg.info ~doc:"IP address to send to" ["ip"] in
  Key.create "ip" Key.Arg.(required string doc)

let port_k =
  let doc = Key.Arg.info ~doc:"Port to send to" ["p"; "port"] in
  Key.create "port" Key.Arg.(required int doc)

let keys = [Key.v ip_k; Key.v port_k]

let main = foreign ~keys "Unikernel.Make" (time @-> stackv4v6 @-> job)

let stack = generic_stackv4v6 default_network

let () =
  let packages = [package "duration"] in
  register "ping-sender" ~packages [main $ default_time $ stack]
