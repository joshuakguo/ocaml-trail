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

val render : shooter -> unit
(** [render s] creates the GUI image of the shooter centered at the
    coordinates defined in [s]. *)
