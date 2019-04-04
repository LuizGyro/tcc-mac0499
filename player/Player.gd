extends Node2D

const MAX_SPEED = 2
const ACCEL = 1.05

var speed = Vector2(1, 1)

func _ready():
	set_process_input(true)
	set_physics_process(true)

func _input(event):
	
	if event.is_action_pressed("touch"):
		move_to(event.position)
		
	elif event.is_action_released("touch"):
		speed = Vector2(1, 1)
		
func move_to(pos):
#	while (pos.distance_to(self.get_global_transform_with_canvas().origin) > 10):
	var direction = (pos - self.get_global_transform_with_canvas().origin).normalized()
	self.position += direction * (speed * ACCEL).clamped(MAX_SPEED)
