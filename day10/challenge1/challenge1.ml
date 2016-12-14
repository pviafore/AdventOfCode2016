open Core.Std
type initial = {bot: string; value: int; }
type give_instruction = {bot: string; low: string; low_type: string; high: string; high_type: string; }
type command = Initial of initial | GiveInstruction of give_instruction

type overflow_instruction = Giver of give_instruction | None
type robot = {value: int; overflow: overflow_instruction; responsible: bool}


module StringMap = Map.Make(String)


let deref_list_string l n = 
   match List.nth l n with
    | None -> "0"
    | Some str -> str

let deref_list l n = int_of_string (deref_list_string l n)

let process_initial str = (Initial {bot=(deref_list_string str 5); value=(deref_list str 1)})
let process_give_instruction str = (GiveInstruction {bot=(deref_list_string str 1); low_type=(deref_list_string str 5); low=(deref_list_string str 6); high=(deref_list_string str 11); high_type=(deref_list_string str 10)})

let make_command str = 
     let l = String.split str ~on: ' ' in
     match List.hd l with
        None -> (Initial {bot=""; value=0;})
        | Some s -> if String.equal s "value" then process_initial l else process_give_instruction l

let rec give_bot_chip number v bots =
match StringMap.find bots number with
  | Some {value; overflow; responsible;} -> 
     if value == 0 then 
       StringMap.add ~key:number ~data:{value=v; overflow=overflow; responsible=responsible;} bots
     else
       match overflow with
        (Giver {bot; low; low_type; high; high_type;}) ->
        let l,h = if v < value then v,value else value,v in
        let sent = (send_to high h high_type (send_to low l low_type bots)) in 
        StringMap.add ~key:number ~data:{value=0; overflow=overflow; responsible=(l,h)=(17,61)} sent
      
  | None -> bots

and send_to dest num t bots =
   print_endline (t^" "^dest^" was sent "^(string_of_int num));
   if String.equal t "output" then
    bots
   else
    give_bot_chip dest num bots

let update_instruction number low high low_type high_type bots =
    StringMap.add ~key:number ~data:{value=0; overflow=(Giver {bot=number;low=low;high=high;low_type=low_type;high_type=high_type;}); responsible=false} bots

let process_command bots command = 
    match command with
     | Initial {bot; value} -> give_bot_chip bot value bots
     | GiveInstruction {bot; low; low_type; high; high_type;} -> update_instruction bot low high low_type high_type bots

let compare_instruction_cast inst =
    match inst with
    | Initial { bot; value; } -> 1
    | GiveInstruction { bot; low; high; _; } -> 0

let compare_instruction in1 in2 = 
    compare (compare_instruction_cast in1) (compare_instruction_cast in2)

let to_bot_string bot = "BOT"

let to_data_string {value; overflow; responsible;} = string_of_int(value)^" "^(if responsible then "Yes" else "No")

let () =
   let file_to_read = "../day10.txt" in 
    let lines = In_channel.read_lines file_to_read in
    let commands = List.map ~f: make_command lines in
    let sorted_commands = List.stable_sort compare_instruction commands in
    let bots = List.fold_left ~f: process_command  ~init: StringMap.empty sorted_commands in
    StringMap.iter ~f:(fun ~key:k ~data:v -> print_endline (k^" "^to_data_string(v))) bots
