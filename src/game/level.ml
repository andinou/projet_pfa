open Ecs
open Component_defs

let create dt = 
	let ic = open_in dt in
	let () =
	try
		let count = ref 0 in
		while true do
			let line = input_line ic in
			match String.split_on_char ',' line with
			[ sx; sy; sw; sh ] -> ignore (Wall.create ("wall" ^ string_of_int !count)
														(float_of_string sx)
														(float_of_string sy)
														(int_of_string sw)
														(int_of_string sh));
														count := !count + 1;
			| _ ->  ()
		done
	with End_of_file -> ()
	in
	false