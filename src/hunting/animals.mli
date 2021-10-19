(** Representation of mutable animal data.

    This module represents the data stored in animal files, the x and y
    coordinates for the center of the animal. It handles the rendering
    and moving of the animal in the game, and the checking of its
    location at the bounds. *)

type animal

val in_bound : float * float * float * float -> animal -> bool

val move : animal -> unit

val rendere_animal_at : float -> float -> unit

val render : animal -> unit
