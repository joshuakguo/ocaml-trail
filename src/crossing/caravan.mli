(** Representation of static caravan data.

    This module represents the data stored in caravan files, the x and y
    coordinates for the center of the caravan. It handles the rendering
    of the caravan in the game. *)

type caravan = {
  mutable x : float;
  mutable y : float;
}
(** The type of values representing the caravan. *)

val collision_area : caravan -> float * float * float * float
(** [collsion_area c] is the square in which collisions can be defined
    from the center of [c]. *)

val render : caravan -> unit
(** [render c] creates the GUI image of the caravan as a rectangle with
    a width of 80 and length of 40, centered at the coordinates defined
    in [c]. *)
