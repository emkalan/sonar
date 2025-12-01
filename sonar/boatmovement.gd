extends Node3D

@export var intervals := 2.0
@export var settle_speed := 1.0
@export var smooth_speed := 8.0
@export var rock_speed := 1.0
@export var rock_amount := 0.1
@export var horizontal_return_speed := 5.0

var time_passed := 0.0
var base_y := 1.5
var target_y := 1.5
var rest_x := 0.0
var being_pushed := false
var push_offset := 0.0
var rest_z := 14.15
var being_pushed_z := false
var push_amount_z := 0.0


var held_notes := {}      # tracks active keys
var current_note := ""  # last pressed key

var note_height := {
	"play_s": intervals * 1,
	"play_d": intervals * 2,
	"play_f": intervals * 3,
	"play_g": intervals * 4,
	"play_h": intervals * 5,
	"play_j": intervals * 6,
	"play_k": intervals * 7,
	"play_l": intervals * 8
}

func _ready():
	target_y = base_y
	base_y = global_transform.origin.y

func _on_piano_controller_note_pressed(note_name: String):
	#print("Boat got note:", note_name)
	if note_name in note_height:
		held_notes[note_name] = true
		current_note = note_name

func _on_piano_controller_note_released(note_name: String):
	held_notes.erase(note_name)
	if current_note == note_name:
		current_note = ""   # reset
		
func apply_track_push(amount: float):
	being_pushed_z = true
	push_amount_z = amount

func _process(delta):
	#print("HI")
	#print(
	#"push:", being_pushed_z,
	#" pos.z:", global_position.z,
	#" rest_z:", rest_z
	#)
	time_passed += delta
	if current_note != "":
		target_y = base_y + note_height[current_note]
	else:
		target_y = lerp(target_y, base_y, delta * settle_speed)

	var pos := global_transform.origin
	pos.y = lerp(pos.y, target_y, delta * smooth_speed)
	pos.x = rest_x
	if being_pushed_z:
		pos.z += push_amount_z
	else:
		pos.z = lerp(pos.z, rest_z, delta * horizontal_return_speed)
	being_pushed_z = false
	global_transform.origin = pos

	rotation.z = sin(time_passed * rock_speed) * rock_amount
