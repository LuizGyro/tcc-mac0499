extends Area2D

export (Vector2) var portal_direction = Vector2(0, 0)
export (PackedScene) var destination

var player

func _ready():
	set_process(false)

func _process(delta):
	player.move_to_absolute(portal_direction)
	

func _on_MapPortal_body_entered(body):
	if (body.get_name().to_lower() == "player"):
		player = body
		
		player.controllable = false
		player.moving = false
		VirtualGamepad.disable()
		player.get_node("Sprite").set_animation("walk")
		
		set_process(true)
		$Timer.start()
		yield($Timer, "timeout")
		# Make scene transition here
		
		# This may not be necessary once the scene transition happens
		set_process(false)
		restore_control()

func restore_control():
	if Global.control_mode == Global.ControlModes.virtual_gamepad:
		VirtualGamepad.enable()
	else:
		player.controllable = true
