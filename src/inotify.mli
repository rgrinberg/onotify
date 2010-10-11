(*
 * Copyright (C) 2010      Ludovic Stordeur <ludovic@okazoo.eu>
 * Copyright (C) 2006-2008 Vincent Hanquez  <vincent@snarc.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; version 2.1 only. with the special
 * exception on linking described in file LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *)

(** Inotify OCaml binding public interface

    @author Ludovic Stordeur
    @author Vincent Hanquez (initial project) *)


(** {1 SYNOPSIS} *)

(** {[
    (* Make this example more readable. *)
    open Inotify
    open Printf

    (* Initialize a new Inotify context and get a handle on it. *)
    let fd = init ()
    
    (* Request for monitoring all events under "/tmp".
       The returned watch descriptor is unused in this example. *)
    let wd = add_watch fd "/tmp" [ Inotify.R_All ]

    (* This is a convenience formatting routine to print an event. *)
    let string_of_ev {wd=wd; mask=mask; cookie=cookie; name=name} =
	let mask = String.concat ":" (List.map string_of_ev_type mask) in
	let name = match name with
	    | Some s -> s
	    | None   -> "\"\"" in
	sprintf "wd[%d] mask[%s] cookie[%ld] %s" wd mask cookie name
	
    (* This example never ends. Send a termination signal to kill it. *)
    let _ = 
        while true
        do
            (* Read the Inotify context.
               This can be a blocking operation, so you can poll the file descriptor before reading it. *)
	    let evs = read fd in

            (* Process all detected events. *)
	    List.iter (fun ev -> printf "%s\n%!" (string_of_ev ev)) evs
        done;
    
        (* Close the Inotify context.
           In this example, this operation is never reached because of the above infinite loop.
           However, this is always a good practice to close file descriptors... ;) *)
        Unix.close fd
    ]}
*)

 
(** {1 API Description} *)

(** Event types to monitor *)
type ev_type_req =
    | R_Access		(** Read access to the file *)
    | R_Attrib		(** Metadata modification *)
    | R_Close_write	(** Write-opened file closed *)
    | R_Close_nowrite	(** Non write-opened file closed *)
    | R_Create		(** File created under the watched directory *)
    | R_Delete		(** File deleted under the watched directory *)
    | R_Delete_self	(** Watched file deleted *)
    | R_Modify		(** File modified *)
    | R_Move_self	(** Watched file moved *)
    | R_Moved_from	(** File moved outside of the watched directory *)
    | R_Moved_to	(** File moved inside the watched directory *)
    | R_Open		(** File opened *)

    | R_All		(** All ABOVE events *)
    | R_Move		(** Moved_from and Moved_to events *)
    | R_Close		(** Close_write and Close_nowrite events *)
    | R_Dont_follow	(** Do not dereference watched file if it is a symbolic link *)
    | R_Mask_add	(** Add events to (instead of replacing) existing ones *)
    | R_Oneshot		(** Watch the file until the first event *)
    | R_Onlydir		(** Watch the file only if it is a directory *)

(** Event types to receive *)
type ev_type =
    | Access		(** Read access to the file *)
    | Attrib		(** Metadata modification *)
    | Close_write	(** Write-opened file closed *)
    | Close_nowrite	(** Non write-opened file closed *)
    | Create		(** File created under the watched directory *)
    | Delete		(** File deleted under the watched directory *)
    | Delete_self	(** Watched file deleted *)
    | Modify		(** File modified *)
    | Move_self		(** Watched file moved *)
    | Moved_from	(** File moved outside of the watched directory *)
    | Moved_to		(** File moved inside the watched directory *)
    | Open		(** File opened *)

    | Ignored		(** The watched file has been removed explicity (rm_watch())
			    or automatically (file deleted or filesystem unmounted) *)
    | Isdir		(** Event subject is a directory *)
    | Q_overflow	(** Event queue overloaded *)
    | Unmount		(** Filesystem containing the watched file has been unmounted *)


(** A watch descriptor *)
type wd = int 


(** Define an event *)
type ev = { wd     : wd;	   (** The associated watch descriptor *)
	    mask   : ev_type list; (** List of received events *)
	    cookie : int32;	   (** Unique identifier used to bind
				       events together. Currently only
				       used to bind Move_from and Move_to *)
	    name   : string option (** Optional name associated to the event *) }
    

val string_of_ev_type : ev_type -> string
(** @return The string representation of [ev_type]. *)

val init : unit -> Unix.file_descr
(** [init] creates a new Inotify context.

    @return A descriptor on the newly created context. *) 

val add_watch : Unix.file_descr -> string -> ev_type_req list -> wd
(** [add_watch fd inode events] adds a new watch point, monitoring for [events] on [inode],
    to the descriptor [fd].
    
    @return A watch descriptor. *)
    
val rm_watch : Unix.file_descr -> wd -> unit
(** [rm_watch fd wd] removes [wd] from the set of watch points associated to [fd]. *)

val read : Unix.file_descr -> ev list
(** [read fd] reads for events associated to the descriptor [fd].

    @return A list of event. *)
