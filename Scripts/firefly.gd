extends CharacterBody2D

@export var staring_wall_normal:= 1

@onready var hurtbox: Area2D = $Hurtbox
@onready var hitbox: Area2D = $Hitbox
@onready var sight_area: Area2D = $SightArea
@onready var dazed_timer: Timer = $Hurtbox/DazedTimer
@onready var buzz_audio: AudioStreamPlayer2D = $BuzzAudio
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer


@export var chase_speed:= 200
@export var retreat_speed:= 50

var starting_pos
var dazed = false

func _ready() -> void: starting_pos = global_position

func _physics_process(delta: float) -> void:
	
	if not dazed:
		
		if sight_area.has_overlapping_bodies():
			
			var target = sight_area.get_overlapping_bodies()[0]
			
			chase(target, delta * chase_speed)
			
			for body in hitbox.get_overlapping_bodies(): 
				if body == target: destroy(target)
			
		else: retreat(delta * retreat_speed)
	
	move_and_slide()
	
	#stop/start animation & sfx depending on movement
	if global_position.is_equal_approx(starting_pos) or dazed: 
		buzz_audio.playing = false
		animation_player.play("IDLE")
	elif buzz_audio.playing == false: 
		buzz_audio.playing = true
		animation_player.current_animation = "FLY"

func chase(target, delta): 
	buzz_audio.pitch_scale = 1.0
	
	#move toward target
	position = position.move_toward(target.position, delta)
	
	#flip sprite
	if target.position.x < position.x: sprite_2d.flip_h = true
	else: sprite_2d.flip_h = false

func destroy(target): target.was_eaten()

func retreat(delta): 
	buzz_audio.pitch_scale = 0.75
	
	#move toward home position
	position = position.move_toward(starting_pos, delta)
	
	#sprite flip
	if staring_wall_normal == 1: sprite_2d.flip_h = true
	else: sprite_2d.flip_h = false

func _on_hurtbox_area_entered(_area: Area2D) -> void: 
	dazed = true
	dazed_timer.start()

func _on_dazed_timer_timeout() -> void: dazed = false
