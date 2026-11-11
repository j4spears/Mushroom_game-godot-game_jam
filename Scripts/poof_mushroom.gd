extends Sprite2D

@onready var poof_area: Area2D = $PoofArea
@onready var collision_shape_2d: CollisionShape2D = $PoofArea/CollisionShape2D
@onready var poof_duration: Timer = $PoofDuration
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rustle_sfx: AudioStreamPlayer2D = $RustleSfx

const pos_of_poof_in_anim := 0.9

var can_poof := true
var poof_aligned := true

func _ready() -> void: 
	
	animation_player.play("GROW")
	rustle_sfx.play()
	
	#dont allow immediate poof (won't align music)
	if Metranome.time_until_hit(Metranome.metranome_A) < pos_of_poof_in_anim:
		can_poof = false
		poof_aligned = false
	
	Metranome.metranome_A.timeout.connect(metranome_hit)
	
	Mushrooms.poof_mushrooms_alive += 1

func _process(_delta: float) -> void:
	
	#begin animation at appropriate time before metranome hit
	if Metranome.time_until_hit(Metranome.metranome_A) < pos_of_poof_in_anim and can_poof:
		
		animation_player.play("POOF")
		can_poof = false

func metranome_hit(): 
	
	if poof_aligned: poof()
	elif not animation_player.is_playing(): 
		can_poof = true
		poof_aligned = true

func poof(): 
	collision_shape_2d.disabled = false
	poof_duration.start()

func _on_poof_duration_timeout() -> void: 
	collision_shape_2d.disabled = true
	can_poof = true
