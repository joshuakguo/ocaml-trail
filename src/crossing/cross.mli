(** Representation of the river crossing mini-game data.

    This module represents the data stored in river crossing mini-game
    files: the movable caravan and obstacles list. It handles the
    rendering of the caravan and obstacles in the mini-game. *)

type cross = {
  mutable over : bool;
  mutable caravan : Caravan.caravan;
  mutable obstacle_list : Obstacle.obstacle list;
}
(** The type of values representing the river crossing mini-game. *)

type direction =
  | Left
  | Right
      (** The type of values representing the direction of movement. *)

type event =
  | Move of direction
  | ScrollObstacles
  | Collisions
      (** The type of values representing the movement of the caravan
          and the obstacles in the mini-game. *)

val controller : cross -> event -> cross
(** [controller c e] controls the movement of the caravan and the
    obstacles in the game. When [e] is a Move of direction, the caravan
    is moved in either left or right depending on direction. When [e] is
    ScrollObstacles, the obstacles in the river are moved at a constant
    pace across the screen.*)

val render : cross -> unit
(** [render c] creates the GUI image of the caravan as a rectangle with
    a width of 80 and length of 40, as well as the obstacles in the
    defined in the obstacles_list of [c]. *)
