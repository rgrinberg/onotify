(* unit testing inotify *)

open Printf

let _ =
    if Array.length Sys.argv < 2 then
	begin
	    eprintf "usage: %s <path>\n" Sys.argv.(0);
	    exit 1
	end;
    
    let fd = Inotify.init () in
    
    let wd =  Inotify.add_watch fd Sys.argv.(1) [ Inotify.R_All ] in
    printf "Retrieved watch descriptor : %d\n%!" wd;

    let string_of_ev ev =
	let wd,mask,cookie,name = (ev.Inotify.wd,
				   ev.Inotify.mask,
				   ev.Inotify.cookie,
				   ev.Inotify.name) in
	let mask = String.concat ":" (List.map Inotify.string_of_ev_type mask) in
	let name = match name with
	    | Some s -> s
	    | None   -> "\"\"" in
	sprintf "wd[%d] mask[%s] cookie[%ld] %s" wd mask cookie name
	
    in
    while true
    do
	let evs = Inotify.read fd in
	List.iter (fun ev -> printf "%s\n%!" (string_of_ev ev)) evs
    done;
	    
    Unix.close fd
