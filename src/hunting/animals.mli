(** Representation of static animal data.

    This module represents the data stored in animal files, the x and y
    coordinates for the center of the animal. It handles the rendering
    and moving of the animal in the game, and the checking of its
    location at the bounds of the window for the game. *)

type animal = {
  mutable x : float;
  y : float;
}
(** The type of values representing animals. *)

(* val in_bound : float * float * float * float -> animal -> bool *)
(** [in_bound (x1, y1, x2, y2) a] is true if the [a] is within the
    bounds (window) of the game and false otherwise. *)

(* val move : animal -> unit *)
(** [move a] moves [a] horizontally by 8.*)

val collision_area : animal -> float * float * float * float
(** [collision_area a] defines the upper and lower bounds of the x and y
    values to the animal. *)

val approach : pace:float -> animal -> animal
(** [approach p] moves an animal horizontally by [p] units per game
    tick.*)

val render : animal -> unit
(** [render a] creates the GUI image of the animal centered at the
    coordinates defined in [a]. *)
