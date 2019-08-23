extends Area2D

export (Vector2) var portal_direction = Vector2(0, 0)
export (PackedScene) var destination

func _on_MapPortal_body_entered(body):
	if (body.get_name().to_lower() == "player"):
		var player = body
		player.controllable = false
		$Timer.start()
		while (!$Timer.is_stopped()):
			player.move_to_absolute(portal_direction)
		# Make scene transition here
