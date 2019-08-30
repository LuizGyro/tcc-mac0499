extends KinematicBody2D

const MAX_SPEED = 200
const ACCEL = 1.05

export var controllable = true

var moving = false
var speed = Vector2(100, 100)

var virtual_gamepad_direction = Vector2(0, 0)

func _ready():
	if (Global.control_mode == Global.ControlModes.direct):
		set_process_input(true)
	elif (Global.control_mode == Global.ControlModes.virtual_gamepad):
		set_process_input(false)
		var status = []
		status.append(VirtualGamepad.connect("up_pressed", self, "determine_gamepad_movement", [Vector2(0, -1)]))
		status.append(VirtualGamepad.connect("down_pressed", self, "determine_gamepad_movement", [Vector2(0, 1)]))
		status.append(VirtualGamepad.connect("left_pressed", self, "determine_gamepad_movement", [Vector2(-1, 0)]))
		status.append(VirtualGamepad.connect("right_pressed", self, "determine_gamepad_movement", [Vector2(1, 0)]))
		status.append(VirtualGamepad.connect("confirm_pressed", self, "determine_and_trigger_interaction"))
		status.append(VirtualGamepad.connect("up_released", self, "determine_gamepad_movement", [Vector2(0, 1)]))
		status.append(VirtualGamepad.connect("down_released", self, "determine_gamepad_movement", [Vector2(0, -1)]))
		status.append(VirtualGamepad.connect("left_released", self, "determine_gamepad_movement", [Vector2(1, 0)]))
		status.append(VirtualGamepad.connect("right_released", self, "determine_gamepad_movement", [Vector2(-1, 0)]))
		
		for code in status:
			if code != 0:
				print("Something went wrong with signal connection in Player!")
		

func _physics_process(delta):
	if Global.control_mode == Global.ControlModes.direct and moving:
		move_to(get_viewport().get_mouse_position())
	elif Global.control_mode == Global.ControlModes.virtual_gamepad and virtual_gamepad_direction != Vector2(0, 0):
		move_to_absolute(virtual_gamepad_direction)
		
##############################################################################################
###################################### Touch Controls ######################################
##############################################################################################

func _input(event):
	
	if !controllable:
		return

	if event.is_action_pressed("touch"):
		# May cause problems if collision layers/masks are set incorrectly, or multiple objects are here
		if ($InteractionBox.get_overlapping_areas() != [] and clicked_on($InteractionBox.get_overlapping_areas()[0].get_parent())):
			var element = $InteractionBox.get_overlapping_areas()[0].get_parent()
			while (!element.has_method("interact")):
				element = element.get_parent()
			element.interact(self)
			yield(element, "interaction_finished")
		
		else:
			moving = true
			$Sprite.set_animation("walk")

	elif event.is_action_released("touch"):
		moving = false
		speed = Vector2(100, 100)
		$Sprite.set_animation("idle")
		
func move_to(pos):
	if (pos.distance_to(self.get_global_transform_with_canvas().origin) > 10):
		var direction = (pos - self.get_global_transform_with_canvas().origin).normalized()
		set_sprite_and_interaction_direction(direction)
		speed = (speed * ACCEL).clamped(MAX_SPEED)
		move_and_slide(direction * speed)

func set_sprite_and_interaction_direction(direction):
	var scale = $Sprite.scale
	if (direction.x > 0):
		$Sprite.set_scale(Vector2(abs(scale.x), scale.y))
		if (direction.y < 0):
			if (abs(direction.x) > abs(direction.y)):
				$InteractionBox.rotation_degrees = 270
			else:
				$InteractionBox.rotation_degrees = 180

		else:
			if (abs(direction.x) > abs(direction.y)):
				$InteractionBox.rotation_degrees = 270

			else:
				$InteractionBox.rotation_degrees = 0

	else:
		# We do this check as a quick fix to VirtualGamepad behaviour
		if (direction.x != 0):
			$Sprite.set_scale(Vector2(-abs(scale.x), scale.y))
		if (direction.y < 0):
			if (abs(direction.x) > abs(direction.y)):
				$InteractionBox.rotation_degrees = 90

			else:
				$InteractionBox.rotation_degrees = 180

		else:
			if (abs(direction.x) > abs(direction.y)):
				$InteractionBox.rotation_degrees = 90

			else:
				$InteractionBox.rotation_degrees = 0
				
func clicked_on(object):
	var mouse_pos = get_viewport().get_mouse_position()
	var absolute_object_position = object.get_global_transform_with_canvas().origin
	
	var posx = absolute_object_position.x
	var posy = absolute_object_position.y
	var sizex = object.size.x * abs(object.scale.x)
	var sizey = object.size.y * abs(object.scale.y)
	print(sizex)
	print(sizey)
	
	
	var min_x = posx - (sizex/2)
	var min_y = posy - (sizey/2)
	var max_x = posx + (sizex/2)
	var max_y = posy + (sizey/2)
	
	print(mouse_pos)
	print(str("min_x: ", min_x, " min_y: ", min_y, " max_x: ", max_x, " max_y: ", max_y))

	if (mouse_pos.x > min_x and mouse_pos.y > min_y and mouse_pos.x < max_x and mouse_pos.y < max_y):
		return true

##############################################################################################
###################################### Gamepad Controls ######################################
##############################################################################################

func determine_gamepad_movement(direction):
	virtual_gamepad_direction += direction
	if (virtual_gamepad_direction != Vector2(0, 0)):
		$Sprite.set_animation("walk")
	else:
		$Sprite.set_animation("idle")
	
func move_to_absolute(pos):
	var direction = (pos).normalized()
	set_sprite_and_interaction_direction(direction)
	speed = (speed * ACCEL).clamped(MAX_SPEED)
	move_and_slide(direction * speed)

func determine_and_trigger_interaction():
	if ($InteractionBox.get_overlapping_areas() != []):
		var element = $InteractionBox.get_overlapping_areas()[0].get_parent()
		element.interact(self)
		yield(element, "interaction_finished")
		
##############################################################################################
###################################### Control Functions######################################
##############################################################################################

func disable_movement():
	self.set_physics_process(false)
	if Global.control_mode == Global.ControlModes.virtual_gamepad:
		VirtualGamepad.disable()

func enable_movement():
	self.set_physics_process(true)
	if Global.control_mode == Global.ControlModes.virtual_gamepad:
		VirtualGamepad.enable()