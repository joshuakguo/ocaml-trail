(** Representation of static shooter data.

    This module represents the data stored in shooter files, the x and y
    coordinates for the center of the shooter. It handles the rendering
    and moving of the shooter in the game, and the checking of its
    location at the bounds of the window for the game. *)

type shooter = {
  mutable x : float;
  y : float;
}
(** The type of values representing the shooter. *)

(* val in_bound : float * float * float * float -> shooter -> bool *)
(** [in_bound (x1, y1, x2, y2) s] is true if the [s] is within the
    bounds (window) of the game and false otherwise. *)

(* val move : shooter -> unit *)
(** [move s] moves [s] horizontally by 8.*)

val render : shooter -> unit
(** [render s] creates the GUI image of the shooter as a square with
    side length 40, centered at the coordinates defined in [s]. *)
