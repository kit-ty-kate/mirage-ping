module Make (_ : Mirage_time.S) (Stack : Tcpip.Stack.V4V6) : sig
  val start : unit -> Stack.t -> unit Lwt.t
end
