# This scene needs to be a direct child of the map root

extends Area2D

export (Vector2) var portal_direction = Vector2(0, 0)
export (String) var destination

var player
onready var source = get_parent()

func _ready():
	set_process(false)

func _process(delta):
	player.move_to_absolute(portal_direction)
	

func _on_MapPortal_body_entered(body):
	if (body.get_name().to_lower() == "player"):
		player = body
		
		player.disable_movement()
		player.moving = false
		VirtualGamepad.disable()
		player.get_node("Sprite").set_animation("walk")
		
		set_process(true)
#		$Timer.start()
#		yield($Timer, "timeout")
		
		GlobalFade.fade_out()
		yield(GlobalFade.tween, "tween_completed")
		
		Global.call_deferred("transition_to_scene", source, destination)