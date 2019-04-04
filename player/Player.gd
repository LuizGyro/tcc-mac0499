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
		moving = true
		$AnimationPlayer.play("Move")
		
	elif event.is_action_released("touch"):
		moving = false
		speed = Vector2(1, 1)
		$AnimationPlayer.play("Idle")
		
func move_to(pos):
	if (pos.distance_to(self.get_global_transform_with_canvas().origin) > 10):
		var direction = (pos - self.get_global_transform_with_canvas().origin).normalized()
		set_sprite_direction(direction)
		speed = (speed * ACCEL).clamped(MAX_SPEED)
		self.position += direction * speed

func set_sprite_direction(direction):
	if (direction.x > 0):
		if (direction.y < 0):
			if (abs(direction.x) > abs(direction.y)):
				$Sprite.set_texture(load("res://assets/placeholder/playerright.png"))
			else:
				$Sprite.set_texture(load("res://assets/placeholder/playerback.png"))
		else:
			if (abs(direction.x) > abs(direction.y)):
				$Sprite.set_texture(load("res://assets/placeholder/playerright.png"))
			else:
				$Sprite.set_texture(load("res://assets/placeholder/playerfront.png"))
	else:
		if (direction.y < 0):
			if (abs(direction.x) > abs(direction.y)):
				$Sprite.set_texture(load("res://assets/placeholder/playerleft.png"))
			else:
				$Sprite.set_texture(load("res://assets/placeholder/playerback.png"))
		else:
			if (abs(direction.x) > abs(direction.y)):
				$Sprite.set_texture(load("res://assets/placeholder/playerleft.png"))
			else:
				$Sprite.set_texture(load("res://assets/placeholder/playerfront.png"))