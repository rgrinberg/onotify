open Ocamlbuild_plugin
open Command


let _ =  dispatch begin function
    | After_rules ->
	    (* Handle the use_stubs flag *)
        dep  ["link"; "ocaml"; "use_stubs"]		["src/stubs/libinotify_stubs.a"];
        flag ["link"; "ocaml"; "byte"; "use_stubs"]	(A"-custom");

	    (* Add the stub linking flags when building library *)
	flag ["link"; "ocaml"; "byte";
	      "file:src/inotify.cma"]			(S[A"-custom"; A"-cclib"; A"-linotify_stubs"]);
	flag ["link"; "ocaml"; "native";
	      "file:src/inotify.cmxa"]			(S[A"-cclib";  A"-linotify_stubs"]);

	flag ["doc"; "ocaml"]				(S[A"-colorize-code"])
    | _ -> ()
end

