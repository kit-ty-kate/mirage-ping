open Mirage

let main = foreign "Unikernel.Make" (stackv4 @-> job)

let stack = generic_stackv4 default_network

let () =
  let packages = [] in
  register "ping-receiver" ~packages [main $ stack]
