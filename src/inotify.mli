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
 *
 * Inotify OCaml binding interface
 *)

(** @author Ludovic Stordeur
    @author Vincent Hanquez *)


exception Error of string * int

(** Events to monitor *)
type ev_req =
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

(** Events to receive *)
type ev =
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
type wd

(** Define an event *)
type event = { wd     : wd;	      (** The associated watch descriptor *)
	       evs    : ev list;      (** List of events *)
	       cookie : int32;	      (** Unique identifier used to bind
					  events together. Currently only
					  used to bind Move_from and Move_to *)
	       name   : string option (** Optional name associated to the event *) }
    

(* val int_of_wd : wd -> int *)

val string_of_ev : ev -> string

val init      : unit -> Unix.file_descr
val add_watch : Unix.file_descr -> string -> ev_req list -> wd
val rm_watch  : Unix.file_descr -> wd -> unit
val read      : Unix.file_descr -> event list
