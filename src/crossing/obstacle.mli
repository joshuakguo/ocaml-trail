(** Representation of static obstacle data.

    This module represents the data stored in obstacle files, the x and
    y coordinates for the center of the obstacles. It handles the
    rendering and moving of the obstacles in the game. *)

type obstacle = {
  mutable x : float;
  mutable y : float;
}
(** The type of values representing obstacles. *)

val collision_area : obstacle -> float * float * float * float
(** [collsion_area o] is the square in which collisions can be defined
    from the center of [o]. *)

val approach : pace:float -> obstacle -> obstacle
(** [move y o] moves [o] vertically at the pace [y].*)

val render : obstacle -> unit
(** [render o] creates the GUI image of the obstacle centered at the
    coordinates defined in [o]. *)
