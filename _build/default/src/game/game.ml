open Ecs
open Component_defs
let chain_functions f_list =
  let funs = ref f_list in
  fun dt -> match !funs with
               [] -> false
              | f :: ll ->
                 if f dt then true
                 else begin
                  funs := ll;
                  true
                 end

let image_storage = Hashtbl.create 16 
let load_image s = Hashtbl.add image_storage s (Gfx.load_image s)
let get_image s = Hashtbl.find image_storage s 
let still_loading _dt =
    not (Hashtbl.fold (fun _ img acc -> acc && Gfx.image_ready img)
    image_storage true)
    
let() = load_image "resources/images/snow.png"
let() = load_image "resources/images/background.png"


let init_player _dt =
  let _level = Level.create "/static/files/level1.txt" in
  let player = Player.create "player" 100.0 300.0 in
  let posp = Position.get player in
  let boxp = Box.get player in
  let xr = (posp.x+.((float_of_int boxp.width)/.2.))-.(800./.2.)in
    let xd = xr-.(mod_float xr 800.) in
    let count = ref 0. in
    while count < ref 8000. do
    ignore (Bg.create (get_image "resources/images/background.png") (!count+.xd) 0.);
    count := !count+.800.;
    done;
	Game_state.init player;
	Input_handler.register_command (KeyDown "z") (Player.jump);
	Input_handler.register_command (KeyUp "z") (Player.stop_jump);
	
  Input_handler.register_command (KeyDown "q") (Player.run_left);
  Input_handler.register_command (KeyUp "q") (Player.stop_run_left);
  Input_handler.register_command (KeyDown "d") (Player.run_right);
  Input_handler.register_command (KeyUp "d") (Player.stop_run_right);
	System.init_all ();
	false

let play_game dt =
	Player.do_move ();
	System.update_all dt;
	true

let end_game _dt =
    let player = Game_state.get_player() in
    let posp = Position.get player in
    if posp.x >= (7950.-.100.) then begin 
    ignore (Level.create "/static/files/level2.txt");
    true
    end
    else false
    
    

let run () =
	Gfx.main_loop
	(chain_functions [
        still_loading;
		init_player;
        end_game;
		play_game
        
	])
