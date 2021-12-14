(** Representation of the hunting mini-game data.

    This module represents the data stored in the hunting mini-game
    files: the movable shooter, bullet list, and animal list. It handles
    the rendering of the shooter, bullets, and animals in the mini-game. *)

type hunt = {
  mutable over : bool;
  mutable shooter : Shooter.shooter;
  mutable bullet_list : Bullet.bullet list;
  mutable animal_list : Animals.animal list;
  mutable kill : int;
  mutable ammo : int;
  mutable food : int;
  mutable bullet_count : int;
}
(** The type of values representing the hunting mini-game. *)

type direction =
  | Left
  | Right
      (** The type of values representing the direction of movement. *)

type event =
  | Shooter of direction
  | Shoot
  | Bullet
  | Animal
  | Collisions
      (** The type of values representing the movement of the shooter,
          bullets, and the animals in the mini-game. *)

exception NoBullets
(** NoBullets raised when bullet_list is empty.*)

val controller : hunt -> event -> hunt
(** [controller h e] controls the movement of the shooter, bullets, and
    animals in the game. When [e] is a MoveShooter of direction, the
    shooter is moved in either Left or Right. When [e] is Shoot, the a
    bullet is added to the bullet list. When [e] is Bullet, the bullets
    move by increment. When [e] is MoveAnimal, the animals are moved at
    a constant pace across the screen. When [e] is Collisions, if there
    an animal and a bullet collide, they are removed from the screen. *)

val render : hunt -> unit
(** [render h] creates the GUI image of the shooter as a square, bullets
    as small squares at the same position as the shooter, and the
    animals in the animals_list of [h]. *)
