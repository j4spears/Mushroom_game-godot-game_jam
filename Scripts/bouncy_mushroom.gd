extends Sprite2D

@export var bounce_strength:= 500

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bounce_duration: Timer = $BounceDuration
@onready var bounce_sfx: AudioStreamPlayer2D = $BounceSfx


const pos_of_bounce_in_anim := 0.2

var can_bounce := true
var bounce_aligned := true

func _ready() -> void: 
	
	#dont allow immediate poof (won't align music)
	if Metranome.time_until_hit(Metranome.metranome_B) < pos_of_bounce_in_anim:
		can_bounce = false
		bounce_aligned = false
	
	bounce_sfx.volume_db = -200000 * Mushrooms.bouncy_mushrooms_alive
	Mushrooms.bouncy_mushrooms_alive += 1
	
	Metranome.metranome_B.timeout.connect(metranome_hit)


func _process(_delta: float) -> void:
	
	#begin animation at appropriate time before metranome hit
	if Metranome.time_until_hit(Metranome.metranome_B) < pos_of_bounce_in_anim and can_bounce:
		
		animation_player.play("BOUNCE")
		can_bounce = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if rotation == 0: body.velocity.y = -500
	elif rotation == PI: body.velocity.y = 500
	elif rotation == PI/2: body.velocity.x = -500
	elif rotation == PI * 3/2: body.velocity.x = 500


func metranome_hit(): 
	
	if bounce_aligned: bounce()
	else: 
		can_bounce = true
		bounce_aligned = true

func bounce(): 
	collision_shape_2d.disabled = false
	bounce_duration.start()
	bounce_sfx.play()

func _on_bounce_duration_timeout() -> void:
	collision_shape_2d.disabled = true
	can_bounce = true
