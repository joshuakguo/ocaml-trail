type obstacle = {
  mutable x : float;
  mutable y : float;
}

let collision_area obstacle =
  ( obstacle.x -. 50.,
    obstacle.x +. 30.,
    obstacle.y -. 30.,
    obstacle.y +. 36. )

let approach ~pace =
  let y = pace in
  fun obstacle ->
    obstacle.y <- obstacle.y -. y;
    (* obstacle.x <- obstacle.x; *)
    obstacle

let render_obstacle_at ~x ~y () =
  GlMat.load_identity ();
  GlMat.translate3 (x, y, 0.);
  GlDraw.begins `polygon;
  GlDraw.color (0.6, 0.6, 0.6);
  List.iter GlDraw.vertex2
    [
      (-70., -35.);
      (-52., 0.);
      (-19., 35.);
      (0., 35.);
      (19., 0.);
      (28., -35.);
    ];

  (* old rock *)
  (* GlDraw.begins `triangles; GlDraw.color (0.6, 0.6, 0.6); List.iter
     GlDraw.vertex2 [ (-50., -30.); (-5., -30.); (-30., 20.) ];
     GlDraw.color (0.5, 0.5, 0.5); List.iter GlDraw.vertex2 [ (-30.,
     -30.); (30., -30.); (30., 30.) ]; GlDraw.color (0.7, 0.7, 0.7);
     List.iter GlDraw.vertex2 [ (-15., -30.); (30., -20.); (30., 36.)
     ]; *)
  GlDraw.ends ()

let render obstacle =
  GlMat.load_identity ();
  GlMat.translate3 (obstacle.x, obstacle.y, 0.);
  render_obstacle_at ~x:obstacle.x ~y:obstacle.y ()
