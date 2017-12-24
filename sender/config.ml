open Mirage

let main = foreign "Unikernel.Make" (time @-> stackv4 @-> job)

let stack = generic_stackv4 default_network

let () =
  let packages = [package "duration"] in
  register "ping-sender" ~packages [main $ default_time $ stack]
