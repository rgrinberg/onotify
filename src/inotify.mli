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

(** Public interface

    @author Ludovic Stordeur
    @author Vincent Hanquez (initial project) *)



(** {2 Inotify overview}

    The {b Inotify} system provides a mechanism for monitoring file system events.
    Inotify can be used to monitor individual files, or to monitor directories.
    When a directory is monitored, Inotify will return events for the directory itself,
    and for files inside the directory.

    {b Inotify} was merged into the 2.6.13 Linux kernel.
    The required library interfaces were added to glibc in version 2.4.

    {i (Extracted from the inotify(7) manpage)}



    {2 A quick example}

    If you are impatient to test this binding, you can cut and paste the following example
    in your favorite editor then save it under a file named example.ml.
    Then, you can compile it with the following command :

    $ ocamlfind ocamlc -package onotify -linkpkg example.ml -o example

    Finally, its execution will monitor all filesystem events which occur directly under
    the /tmp directory and report them on the standard output.

    {[
    (* Make this example more readable. *)
    open Inotify

    (* Initialize a new Inotify instance and get a file descriptor on it. *)
    let fd = init ()

    (* Request for monitoring all event types under "/tmp".
       The returned watch descriptor is unused in this example. *)
    let wd = add_watch fd "/tmp" [ Inotify.R_All ]

    (* This is a convenience formatting routine to print an event. *)
    let string_of_ev {wd=wd; mask=mask; cookie=cookie; name=name} =
	let mask = String.concat ":" (List.map string_of_ev_type mask) in
	let name = match name with
	    | Some s -> s
	    | None   -> "\"\"" in
	Printf.sprintf "wd[%d] mask[%s] cookie[%ld] %s" wd mask cookie name

    (* This example never ends. Send a termination signal to kill it. *)
    let _ =
        while true
        do
            (* Read the file descriptor attached to the Inotify instance.
               This can be a blocking operation, so you can poll the file descriptor
	       with a timeout before reading it. *)
	    let evs = read fd in

            (* Process all detected events. *)
	    List.iter (fun ev -> printf "%s\n%!" (string_of_ev ev)) evs
        done;

        (* Close the file descriptor attached to the Inotify instance.
           In this example, this operation is never reached because of the above infinite loop.
           However, this is always a good practice to close file descriptors... ;) *)
        Unix.close fd
    ]} *)



(** {2 The Inotify first step}

    The first function to call if you wish to use Inotify is [init]. *)

val init : unit -> Unix.file_descr
(** [init] creates a new {b Inotify instance} and returns a file descriptor referring to this instance.
    At the end, this descriptor must be closed using [Unix.close]. *)

(** You can perfectly creates several Inotify instance which can be attached different watch points.
    This can be usefull if you wish, at a given time, to monitor just a subset of all your managed watch points. *)



(** {2 Attaching watch points}

    Once you have an Inotify instance. You can attach it some watch points using [add_watch].
    This function takes a list of event types you wish to monitor for this watch point. *)

(** [add_watch] returns a {b watch descriptor} associated to this watch point : *)

type wd = int

(** The exhaustive event type list that [add_watch] can receive is given here : *)

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


val add_watch : Unix.file_descr -> string -> ev_type_req list -> wd
(** [add_watch fd inode events] attaches a new watch point to the instance [fd],
    monitoring for [events] on [inode].
    It returns a watch descriptor on this watch point. *)



(** {2 Monitoring for events on an Inotify instance}

    The monitoring of an Inotify instance is performed by reading the file descriptor attached
    to this instance, using the function [read].
    This function is blocking until some events occur on one or several watch points bound to the instance.

    [read] returns a list of events, each of them related to a watch point.
    Each event contains the list of event types which have occured.

    The exhaustive event type list that an event can contain is given here : *)

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

(** The definition of an event related to a watch point is given here : *)

type ev = { wd     : wd;	   (** The associated watch descriptor *)
	    mask   : ev_type list; (** List of received events *)
	    cookie : int32;	   (** Unique identifier used to bind
				       events together. Currently only
				       used to bind Move_from and Move_to *)
	    name   : string option (** Optional name associated to the event *) }


val read : Unix.file_descr -> ev list
(** [read fd] reads for events associated to the descriptor [fd] and returns a list of events.
    If there is no pending event when calling this function, [read] blocks until some event occur. *)



(** {2 Other functions} *)

val rm_watch : Unix.file_descr -> wd -> unit
(** [rm_watch fd wd] removes [wd] from the set of watch points associated to [fd]. *)

val string_of_ev_type : ev_type -> string
(** [string_of_ev_type ev_type] returns the string representation of [ev_type]. *)



