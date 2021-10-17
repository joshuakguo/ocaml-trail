type caravan = {
  mutable x : float;
  mutable y : float;
}

let collision_area obstacle =
  ( obstacle.x -. 5.,
    obstacle.x +. 5.,
    obstacle.y -. 5.,
    obstacle.y +. 5. )

let render_caravan_at ~x ~y =
  GlMat.load_identity ();
  GlMat.translate3 (x, y, 0.);
  GlDraw.color (1., 1., 1.);
  GlDraw.begins `quads;
  List.iter GlDraw.vertex2
    [ (-1., -1.); (1., -1.); (1., 1.); (-1., 1.) ];
  GlDraw.ends ()

let render caravan = render_caravan_at ~x:caravan.x ~y:caravan.y
