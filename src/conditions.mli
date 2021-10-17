(** Representation of player status.

    This module represents the status of the player. It handles the
    updating of each condition. *)

val money : int
(** [money] is the amount of money the player has. Requires: [money] >=
    0. *)

val days_passed : int
(** [days_passed] is the number of days that has passed. Requires:
    [days_passed] >= 0. *)

val miles_traveled : int
(** [miles_traveled] is the number of miles the player has traveled, in
    miles. Requires: [miles_traveled] >= 0. *)

val pace : int
(** [pace] is the pace at which the player is traveling, in miles per
    day. Requires: [pace] >= 0. *)

val health : int
(** [health] is the health of the player throughout the game, out of
    100. Requires: [health] >= 0. *)

val camels : int
(** [camels] is the number of the camels the player has. Requires:
    [camels] >= 0. *)

val food : int
(** [food] is the amount of food the player has, in pounds. Requires:
    [food] >= 0. *)

val ration : int
(** [ration] is the rate at which the player consumes food, in pounds
    per day. Requires: [ration] >= 0.*)

val ammo : int
(** [ammo] is the number of bullets the player has, in cases where each
    case contains 10 bullets. Requires: [ammo] >= 0. *)

val clothes : int
(** [clothes] is the number of sets of clothing the player has.
    Requires: [clothes] >= 0. *)

val parts : int
(** [parts] is the number of caravan parts the player has. Requires:
    [parts] >= 0. *)

val dead : bool
(** [dead] is true if player's health is <= 0, false otherwise. *)