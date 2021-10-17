(* type size = ? *)

type obstacle = {
  mutable x : float;
  mutable y : float;
}

let collision_area obstacle =
  ( obstacle.x -. 5.,
    obstacle.x +. 5.,
    obstacle.y -. 5.,
    obstacle.y +. 5. )

let approach ~pace =
  let y = pace in
  fun obstacle ->
    obstacle.y <- obstacle.y -. y;
    obstacle.x <- obstacle.x;
    obstacle

let render_rock () =
  GlDraw.color (0.5, 0.5, 0.5);
  GlDraw.begins `triangles;
  List.iter GlDraw.vertex2 [ (-1., -1.); (1., -1.); (0., 1.) ];
  GlDraw.ends ()

let render_obstacle obstacle =
  GlMat.load_identity ();
  GlMat.translate3 (obstacle.x, obstacle.y, 0.);
  render_rock ()
