(** Representation of the game data.

    This module represents the data stored in a game, the x and y
    coordinates for the center of the caravan. It handles the rendering
    of the caravan in the game. *)

type game_state =
  | Crossing
  | Hunting
      (** The abstract type of values representing the current state of
          the game. *)

type game = {
  mutable game_state : game_state;
  mutable crossing : Crossing.Cross.cross;
  mutable hunt : Hunting.Hunt.hunt;
  mutable money : int;
  mutable days_passed : int;
  mutable miles_traveled : int;
  mutable pace : int;
  mutable health : int;
  mutable camels : int;
  mutable food : int;
  mutable ration : int;
  mutable ammo : int;
  mutable clothes : int;
  mutable parts : int;
  mutable dead : bool; (* mutable kill : int; *)
}
(** The abstract type of values representing a game. *)

val render_hunting : Hunting.Hunt.hunt -> unit
(** [render_hunting game] renders the hunting minigame specified by
    [game]. *)

val render_crossing : Crossing.Cross.cross -> unit
(** [render_crossing game] renders the river crossing minigame specified
    by [game]. *)

val init : unit -> game
(** [init] is the initial state of a game. *)

val init_hunt : game:game -> unit
(** [init_hunt game] initializes the keyboard capture and ticker
    required by the hunting minigame specified by [game]. *)

val init_crossing : game:game -> unit
(** [init_crossing game] initializes the keyboard capture and ticker
    required by the river crossing minigame specified by [game] *)

val render : game -> unit
(** [render game] renders the main game and minigames as specified by
    the game_state of [game] *)

val animal_coll_ticker : game -> value:int -> unit