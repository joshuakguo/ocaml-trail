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
  GlDraw.color (0.6, 0.6, 0.6);
  GlDraw.begins `quads;
  List.iter GlDraw.vertex2 
    [ (-10., -15.); (10., 15.); (-10., 15.); (10., -15.) ];
  GlDraw.ends ()
  GlDraw.color (0.25, 0.25, 0.25);
  GlDraw.begins `triangles;
  List.iter GlDraw.vertex2
    [ (-40., -20.); (40., -20.); (40., 20.); ];
  List.iter GlDraw.vertex2
    [ (-40., -20.); ; (40., 20.); (-40., 20.) ];
  GlDraw.ends ()

let render caravan = render_caravan_at ~x:caravan.x ~y:caravan.y
