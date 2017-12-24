open Mirage

let port_k =
  let doc = Key.Arg.info ~doc:"Port to listen to" ["p"; "port"] in
  Key.create "port" Key.Arg.(required int doc)

let keys = [Key.abstract port_k]

let main = foreign ~keys "Unikernel.Make" (stackv4 @-> job)

let stack = generic_stackv4 default_network

let () =
  let packages = [] in
  register "ping-receiver" ~packages [main $ stack]
