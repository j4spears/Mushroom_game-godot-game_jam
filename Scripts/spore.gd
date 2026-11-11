extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var gravity:= 20
@export var max_velocity:= 500

var spore_type
signal landed
signal eaten

func init(initial_velocity, this_spore_type) -> void: 
	velocity = initial_velocity
	spore_type = this_spore_type
	
	if spore_type != Spores.Types.DEFAULT: set_collision_mask_value(4, true)

func _physics_process(_delta: float) -> void:
	
	#update velocity
	velocity.y += gravity
	velocity = velocity.limit_length(max_velocity)
	
	#check collision
	if get_slide_collision_count() != 0:
		
		#get collider
		var collision = get_slide_collision(0)
		var collider = get_slide_collision(0).get_collider()
		
		if collider.is_in_group("Moss"): 
			
			if spore_type == Spores.Types.DEFAULT: move_player(collision)
			else: grow_mushroom(collision)
			
		else: was_eaten()
	
	move_and_slide()

func move_player(collision):
	landed.emit(global_position, collision.get_normal())
	queue_free()

func was_eaten(): 
	eaten.emit()
	queue_free()

func grow_mushroom(collision):
	
	var new_mushroom
	
	match spore_type:
		Spores.Types.BOUNCY: new_mushroom = Mushrooms.BOUNCY.instantiate()
		Spores.Types.POOF: new_mushroom = Mushrooms.POOF.instantiate()
		Spores.Types.MOSS: new_mushroom = Mushrooms.MOSS.instantiate()
	
	new_mushroom.global_position = global_position
	
	#rotate and snap to grid
	if collision.get_normal().y > 0.5: 
		new_mushroom.rotation = PI
		#new_mushroom.position.x = snapped(global_position.x, 32) + 16
		new_mushroom.position.x = floor(global_position.x/32) * 32 + 16
	elif collision.get_normal().y < -0.5: 
		new_mushroom.rotation = 0
		#new_mushroom.position.x = snapped(global_position.x, 32) + 16
		new_mushroom.position.x = floor(global_position.x/32) * 32 + 16
	elif collision.get_normal().x > 0.5: 
		new_mushroom.rotation = PI/2
		#new_mushroom.position.y = snapped(global_position.y, 32) - 16
		new_mushroom.position.y = floor(global_position.y/32) * 32 - 16
	elif collision.get_normal().x < -0.5: 
		new_mushroom.rotation = PI* 3/2
		#new_mushroom.position.y = snapped(global_position.y, 32) - 16
		new_mushroom.position.y = floor(global_position.y/32) * 32 - 16
	
	add_sibling(new_mushroom)
	
	queue_free()
