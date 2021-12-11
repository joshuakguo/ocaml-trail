let init_display ~w ~h ~title =
  Glut.initDisplayMode ~double_buffer:true ~depth:true ~alpha:true ();
  Glut.initWindowSize ~w ~h;
  ignore (Glut.createWindow ~title);
  Glut.idleFunc ~cb:(Some Glut.postRedisplay)

let init_view ~w ~h =
  GlDraw.viewport ~x:0 ~y:0 ~w ~h;
  GlMat.mode `projection;
  GlMat.load_identity ();
  GluMat.ortho2d ~x:(0.0, float_of_int w) ~y:(0.0, float_of_int h);
  GlMat.mode `modelview

let init_engine ~game ~w ~h =
  init_display ~w ~h ~title:"OCaml Trail";
  init_view ~w ~h;
  Game.init_game ~game;
  Glut.displayFunc ~cb:(fun () -> Game.render game);
  Glut.mainLoop

let () =
  ignore @@ Glut.init ~argv:Sys.argv;
  let game = Game.init () in
  let run = init_engine ~game ~w:800 ~h:525 in
  run ()
