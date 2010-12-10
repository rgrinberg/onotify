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
 * Inotify OCaml binding implementation
 *)


type ev_type_req =
    | R_Access
    | R_Attrib
    | R_Close_write
    | R_Close_nowrite
    | R_Create
    | R_Delete
    | R_Delete_self
    | R_Modify
    | R_Move_self
    | R_Moved_from
    | R_Moved_to
    | R_Open

    | R_All
    | R_Move
    | R_Close
    | R_Dont_follow
    | R_Mask_add
    | R_Oneshot
    | R_Onlydir


type ev_type =
    | Access
    | Attrib
    | Close_write
    | Close_nowrite
    | Create
    | Delete
    | Delete_self
    | Modify
    | Move_self
    | Moved_from
    | Moved_to
    | Open

    | Ignored
    | Isdir
    | Q_overflow
    | Unmount


let string_of_ev_type = function
    | Access		-> "ACCESS"
    | Attrib		-> "ATTRIB"
    | Close_write	-> "CLOSE_WRITE"
    | Close_nowrite	-> "CLOSE_NOWRITE"
    | Create		-> "CREATE"
    | Delete		-> "DELETE"
    | Delete_self	-> "DELETE_SELF"
    | Modify		-> "MODIFY"
    | Move_self		-> "MOVE_SELF"
    | Moved_from	-> "MOVED_FROM"
    | Moved_to		-> "MOVED_TO"
    | Open		-> "OPEN"
    | Ignored		-> "IGNORED"
    | Isdir		-> "ISDIR"
    | Q_overflow	-> "Q_OVERFLOW"
    | Unmount		-> "UNMOUNT"


type wd = int

type ev = { wd     : wd;
	    mask   : ev_type list;
	    cookie : int32;
	    name   : string option }

external init	     : unit -> Unix.file_descr				   = "stub_inotify_init"
external add_watch   : Unix.file_descr -> string -> ev_type_req list -> wd = "stub_inotify_add_watch"
external rm_watch    : Unix.file_descr -> wd -> unit			   = "stub_inotify_rm_watch"

external convert     : string -> (wd * ev_type list * int32 * int)	   = "stub_inotify_convert"
external struct_size : unit -> int					   = "stub_inotify_struct_size"
external to_read     : Unix.file_descr -> int				   = "stub_inotify_ioctl_fionread"


let read fd =
    let _,_,_  = Unix.select [fd] [] [] (-1.) in
    let ss     = struct_size () in
    let toread = to_read fd in

    let ret    = ref [] in
    let buf    = String.make toread '\000' in
    let toread = Unix.read fd buf 0 toread in

    let read_c_string offset len =
	let index = ref 0 in
	while !index < len && buf.[offset + !index] <> '\000' do
	    incr index
	done;
	String.sub buf offset !index
    in

    let i = ref 0 in
    while !i < toread do
	let wd,mask,cookie,len = convert (String.sub buf !i ss) in
	let s =
	    if len > 0 then
		Some (read_c_string (!i + ss) len)
	    else
		None
	in
	ret := {wd=wd; mask=mask; cookie=cookie; name=s} :: !ret;
	i := !i + (ss + len)
    done;

    List.rev !ret
