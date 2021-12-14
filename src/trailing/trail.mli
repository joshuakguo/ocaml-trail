(** Representation of the main Ocaml Trail game data.

    This module represents the data stored in the main game. It handles
    changes in game_states, updates relevant fields, and renders all
    aspects of the main game. *)

type t = {
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
  mutable dead : bool;
  mutable input_string : string;
}
(** The abstract type of representing the game. *)

type event =
  | Choice
  | Advance
  | Arrive
  | Shop
      (** The abstract type of values representing the event within the
          game. *)

val controller : t -> event -> t
(** [controller t e] changes the frame and updates fields according to
    the player's decisions. When [e] is Choice, player can continue on
    the trail, check supplies, hunt for food. When [e] is Advance, the
    player advances in the map and the background is moved across the
    screen. When [e] is Arrive, the player arrives at a landmark. When
    [e] is Shop, the player can buy supplies and [money], [food],
    [camels], [parts], [clothes], are updated accordingly. *)

val render : t -> unit
(** [render game] renders the game as specified by the game_state of
    [game] *)
