extends Node2D

const MAX_SPEED = 5
const ACCEL = 1.05

var moving = false
var speed = Vector2(1, 1)

func _ready():
	set_process_input(true)
	set_physics_process(true)

func _physics_process(delta):
	if moving:
		move_to(get_viewport().get_mouse_position())

func _input(event):
	
	if event.is_action_pressed("touch"):
		# May cause problems if collision layers/masks are set incorrectly, or multiple objects are here
		if ($InteractionBox.get_overlapping_areas() != [] and clicked_on($InteractionBox.get_overlapping_areas()[0].get_parent())):
			$InteractionBox.get_overlapping_areas()[0].get_parent().interact()
		else:
			moving = true
			$AnimationPlayer.play("Move")
		
	elif event.is_action_released("touch"):
		moving = false
		speed = Vector2(1, 1)
		$AnimationPlayer.play("Idle")
		
func move_to(pos):
	if (pos.distance_to(self.get_global_transform_with_canvas().origin) > 10):
		var direction = (pos - self.get_global_transform_with_canvas().origin).normalized()
		set_sprite_and_interaction_direction(direction)
		speed = (speed * ACCEL).clamped(MAX_SPEED)
		self.position += direction * speed

func set_sprite_and_interaction_direction(direction):
	if (direction.x > 0):
		if (direction.y < 0):
			if (abs(direction.x) > abs(direction.y)):
				$Sprite.set_texture(load("res://assets/placeholder/playerright.png"))
				$InteractionBox.rotation_degrees = 270
			else:
				$Sprite.set_texture(load("res://assets/placeholder/playerback.png"))
				$InteractionBox.rotation_degrees = 180
				
		else:
			if (abs(direction.x) > abs(direction.y)):
				$Sprite.set_texture(load("res://assets/placeholder/playerright.png"))
				$InteractionBox.rotation_degrees = 270
				
			else:
				$Sprite.set_texture(load("res://assets/placeholder/playerfront.png"))
				$InteractionBox.rotation_degrees = 0
				
	else:
		if (direction.y < 0):
			if (abs(direction.x) > abs(direction.y)):
				$Sprite.set_texture(load("res://assets/placeholder/playerleft.png"))
				$InteractionBox.rotation_degrees = 90
				
			else:
				$Sprite.set_texture(load("res://assets/placeholder/playerback.png"))
				$InteractionBox.rotation_degrees = 180
				
		else:
			if (abs(direction.x) > abs(direction.y)):
				$Sprite.set_texture(load("res://assets/placeholder/playerleft.png"))
				$InteractionBox.rotation_degrees = 90
				
			else:
				$Sprite.set_texture(load("res://assets/placeholder/playerfront.png"))
				$InteractionBox.rotation_degrees = 0
				
func clicked_on(object):
	var mouse_pos = get_viewport().get_mouse_position()
	var absolute_object_position = object.get_global_transform_with_canvas().origin
	
	var posx = absolute_object_position.x
	var posy = absolute_object_position.y
	var sizex = object.size.x
	var sizey = object.size.y
	
	var min_x = posx - (sizex/2)
	var min_y = posy - (sizey/2)
	var max_x = posx + (sizex/2)
	var max_y = posy + (sizey/2)
	
#	print(mouse_pos)
#	print(str("min_x: ", min_x, " min_y: ", min_y, " max_x: ", max_x, " max_y: ", max_y))

	if (mouse_pos.x > min_x and mouse_pos.y > min_y and mouse_pos.x < max_x and mouse_pos.y < max_y):
		return true 