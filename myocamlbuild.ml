 open Ocamlbuild_plugin
 open Command
 
 
 let _ =  dispatch begin function
     | After_rules ->
           dep  ["link"; "ocaml"; "use_stubs"]		 ["src/stubs/libinotify_stubs.a"];

           flag ["link"; "ocaml"; "byte"; "use_stubs"]   (A"-custom");
	   
	   flag ["link"; "ocaml"; "byte"; "stubflags"]   (S[A"-custom"; A"-cclib"; A"-linotify_stubs"]);
	   flag ["link"; "ocaml"; "native"; "stubflags"] (S[A"-cclib";  A"-linotify_stubs"]);
	   
	   flag ["doc"; "ocaml"]			 (S[A"-colorize-code"])
     | _ -> ()
 end
