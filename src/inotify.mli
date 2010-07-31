(*
 * Copyright (C) 2006-2008 Vincent Hanquez <vincent@snarc.org>
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
 * Inotify OCaml binding
 *)

(** @author Vincent Hanquez
    @author Ludovic Stordeur *)

exception Error of string * int

(** Available events *)
type ev_type =
| Access	(** Read access to the file *)
| Attrib	(** Metadata modification *)
| Close_write	(** Write-opened file closed *)
| Close_nowrite (** Non write-opened file closed *)
| Create	(** File created under the watched directory *)
| Delete	(** File deleted under the watched directory *)
| Delete_self	(** Watched file deleted *)
| Modify	(** File modified *)
| Move_self	(** Watched file moved *)
| Moved_from	(** File moved outside of the watched directory *)
| Moved_to	(** File moved inside the watched directory *)
| Open		(** File opened *)
| All		(** All ABOVE events *)

| Move		(** Moved_from and Moved_to events *)
| Close		(** Close_write and Close_nowrite events *)

| Dont_follow	(** Do not dereference watched file if it is a symbolic
		    link. add_watch() only *)
| Mask_add	(** Add events to (instead of replacing) existing ones.
		    add_watch() only *)
| Oneshot	(** Watch the file until the first event.
		    add_watch() only *)
| Onlydir	(** Watch the file only if it is a directory *)

| Ignored	(** The watched file has been removed explicity
		    (rm_watch()) or automatically (file deleted or
		    filesystem unmounted). read() only *)
| Isdir		(** Event subject is a directory. read() only *)
| Q_overflow	(** Event queue overloaded. read() only *)
| Unmount	(** Filesystem containing the watched file has been
		    unmounted. read() only *)

(** A watch descriptor *)
type wd

(** Define an event *)
type ev = { wd	   : wd;	    (** The associated watch descriptor *)
	    evs    : ev_type list;  (** List of events *)
	    cookie : int32;	    (** Unique identifier used to bind
					events together. Currently only
					used to bind Move_from and Move_to *)
	    name   : string option  (** Optional name associated to the event *) }
    

(* val int_of_wd : wd -> int *)

val string_of_ev_type : ev_type -> string

val init      : unit -> Unix.file_descr
val add_watch : Unix.file_descr -> string -> ev_type list -> wd
val rm_watch  : Unix.file_descr -> wd -> unit
val read      : Unix.file_descr -> ev list
