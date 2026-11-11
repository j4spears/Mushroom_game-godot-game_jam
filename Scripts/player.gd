extends Sprite2D

@export var spore: PackedScene
@onready var mouth: Marker2D = $Mouth
@onready var spit_audio: AudioStreamPlayer2D = $SpitAudio


var selected_spore = Spores.Types.DEFAULT
var can_shoot_default:= true


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("hotbar_input"): select_spore(event)
	
	if event.is_action_pressed("shoot"): aim()
	
	if event.is_action_released("shoot"): 
		if selected_spore == Spores.Types.DEFAULT and not can_shoot_default: pass
		else: shoot(selected_spore)

func select_spore(event):
	
	if event.is_action("hotbar_1"):
		if selected_spore == Spores.Types.BOUNCY: selected_spore = Spores.Types.DEFAULT
		else: selected_spore = Spores.Types.BOUNCY
		
	elif event.is_action("hotbar_2"):
		if selected_spore == Spores.Types.POOF: selected_spore = Spores.Types.DEFAULT
		else: selected_spore = Spores.Types.POOF
		
	elif event.is_action("hotbar_3"):
		if selected_spore == Spores.Types.MOSS: selected_spore = Spores.Types.DEFAULT
		else: selected_spore = Spores.Types.MOSS

func aim(): pass

func shoot(this_spore_type): 
	
	#create spore
	var this_spore = spore.instantiate()
	this_spore.global_position = mouth.global_position
	
	#give velocity based on mouse position relative to player
	var initial_velocity = (mouth.global_position - get_global_mouse_position()) * 10
	this_spore.init(initial_velocity, this_spore_type)
	
	if this_spore_type == Spores.Types.DEFAULT: 
		can_shoot_default = false
		this_spore.landed.connect(on_default_spore_land)
		this_spore.eaten.connect(on_default_spore_eaten)
	
	#play audio
	spit_audio.pitch_scale = randf_range(0.9, 1.1)
	spit_audio.play()
	
	add_sibling(this_spore)


func on_default_spore_land(spore_landing_pos, collision_normal): 
	
	#move player
	global_position = spore_landing_pos
	
	#rotate player
	if collision_normal.y > 0.5: rotation = PI
	elif collision_normal.y < -0.5: rotation = 0
	elif collision_normal.x > 0.5: rotation = PI/2
	elif collision_normal.x < -0.5: rotation = PI* 3/2
	
	can_shoot_default = true

func on_default_spore_eaten(): can_shoot_default = true
