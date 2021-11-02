val init_display : w:int -> h:int -> title:string -> unit
(** [init_display ~w ~h ~title] initializes an OpenGL display with width
    ~w, height ~h, and title ~title. *)

val init_view : w:int -> h:int -> unit
(** [init_view ~w ~h ] initializes an OpenGL window with width ~w and
    height ~h. *)

val init_engine : game:Game.game -> w:int -> h:int -> unit -> unit
