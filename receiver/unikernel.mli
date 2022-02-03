module Make (Stack : Tcpip.Stack.V4V6) : sig
  val start : Stack.t -> unit Lwt.t
end
