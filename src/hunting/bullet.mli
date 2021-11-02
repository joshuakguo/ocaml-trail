(** Representation of static bullet data.

    This module represents the data stored in bullet files, the x and y
    coordinates for the center of the bullets. It handles the rendering
    and moving of the bullets in the game, and the checking of its
    location at the bounds of the window for the game. *)

type bullet = {
  mutable x : float;
  mutable y : float;
}
(** The type of values representing bullets. *)

(* val collision_area : bullet -> float * float * float * float *)
(** [collsion_area b] is the square in which collisions can be defined
    from the center of [b]. *)

val in_bound : bounds:float * float * float * float -> bullet -> bool
(** [in_bound (x1, y1, x2, y2) b] is true if the [b] is within the
    bounds (window) of the game and false otherwise. *)

val move : bullet -> bullet
(** [move b] moves [b] horizontally by 8.*)

val render : bullet -> unit
(** [render b] creates the GUI image of the bullet as a square with side
    length 10, centered at the coordinates defined in [b]. *)
