module Make (_ : Mirage_time.S) (Stack : Tcpip.Stack.V4) : sig
  val start : unit -> Stack.t -> unit Lwt.t
end
