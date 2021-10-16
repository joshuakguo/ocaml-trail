open Glut

let initDisplay ~w ~h ~title =
  Glut.initDisplayMode ~double_buffer:true ~depth:true ~alpha:true ();
  Glut.initWindowSize ~w ~h;
  Glut.createWindow ~title;
  Glut.idleFunc ~cb:(Some Glut.postRedisplay)

let initView ~w ~h =
  GlDraw.viewport ~x:0 ~y:0 ~w ~h;
  GlMat.mode `projection;
  GlMat.load_identity ();
  GluMat.ortho2d ~x:(0.0, float_of_int(w)) ~y:(0.0, float_of_int(h));
  GlMat.mode `modelview

let initEngine ~w ~h = 
  initDisplay ~w ~h ~title: "OCaml Trail";
  initView ~w ~h;
  Glut.displayFunc (fun () -> ());
  Glut.mainLoop

let () =
  ignore @@ Glut.init Sys.argv;
  let run = initEngine ~w:500 ~h:500 in
    run()