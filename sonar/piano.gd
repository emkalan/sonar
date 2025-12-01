extends Node

var attack_sounds = {}
var sustain_sounds = {}

signal note_pressed(note_name)
signal note_released(note_name)

func fade_out_and_stop(player: AudioStreamPlayer, time := 0.12) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(player, "volume_db", -40, time)
	tween.connect("finished", func():
		player.stop()
		player.volume_db = 0
	)

func _ready() -> void:
	attack_sounds = {
		"play_s": $SOgg,
		"play_d": $DOgg,
		"play_f": $FOgg,
		"play_g": $GOgg,
		"play_h": $HOgg,
		"play_j": $JOgg,
		"play_k": $KOgg,
		"play_l": $LOgg,
	}

	sustain_sounds = {
		"play_s": $Ssus,
		"play_d": $Dsus,
		"play_f": $Fsus,
		"play_g": $Gsus,
		"play_h": $Hsus,
		"play_j": $Jsus,
		"play_k": $Ksus,
		"play_l": $Lsus,
	}


func _input(event):
	for action in attack_sounds.keys():
		if event.is_action_pressed(action):
			attack_sounds[action].play()

			var sus = sustain_sounds[action]
			sus.play()      # start looping sustain
			emit_signal("note_pressed", action)

		elif event.is_action_released(action):
			fade_out_and_stop(sustain_sounds[action])
			emit_signal("note_released", action)
