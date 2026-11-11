extends CharacterBody2D

@onready var dazed_timer: Timer = $DazedTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var eat_audio: AudioStreamPlayer2D = $EatAudio


var dazed := false

func _on_hurt_box_area_entered(_area: Area2D) -> void:
	dazed = true
	dazed_timer.start()

func _on_dazed_timer_timeout() -> void:
	dazed = false

func _on_site_area_body_entered(body: Node2D) -> void:
	
	if not dazed: 
		animation_player.play("EAT")
		eat_audio.pitch_scale = randf_range(0.9,1.1)
		eat_audio.play()
		body.was_eaten()
