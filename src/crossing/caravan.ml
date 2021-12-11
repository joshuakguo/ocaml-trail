type caravan = {
  mutable x : float;
  mutable y : float;
}

let collision_area obstacle =
  ( obstacle.x -. 40.,
    obstacle.y -. 20.,
    obstacle.x +. 40.,
    obstacle.y +. 20. )

let render_caravan_at ~x ~y =
  (* background *)
  (* GlMat.load_identity (); GlMat.translate3 (400., 262.5, 0.);
     GlDraw.color (0.2, 0.4, 1.); GlDraw.begins `quads; List.iter
     GlDraw.vertex2 [ (-400., -262.5); (-400., 262.5); (400., 262.5);
     (400., -262.5) ]; GlDraw.ends (); *)

  (* ship *)
  GlMat.load_identity ();
  GlMat.translate3 (x, y, 0.);

  (* GlDraw.color (1., 0., 0.); GlDraw.begins `triangles; List.iter
     GlDraw.vertex2 [ ()] *)

  (* GlDraw.color (0.6, 0.6, 0.6); GlDraw.begins `quads; List.iter
     GlDraw.vertex2 [ (-10., -15.); (10., 15.); (-10., 15.); (10., -15.)
     ]; GlDraw.ends (); *)
  GlDraw.color (0.25, 0.25, 0.25);
  GlDraw.begins `triangles;
  List.iter GlDraw.vertex2 [ (-40., -20.); (40., -20.); (40., 20.) ];
  List.iter GlDraw.vertex2 [ (-40., -20.); (40., -20.); (-40., 20.) ];
  GlDraw.ends ()

let render caravan = render_caravan_at ~x:caravan.x ~y:caravan.y
