 open Ocamlbuild_plugin
 open Command
 
 
 let _ =  dispatch begin function
     | After_rules ->
             dep ["link"; "ocaml"; "native"; "use_stubs"] ["src/stubs/libinotify_stubs.a"];
     | _ -> ()
 end
