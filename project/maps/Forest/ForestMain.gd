extends Node2D

# This is the map the player is coming from
var source_name = "none"

func _ready():
	if (source_name == "ForestWake"):
		$Player.disable_movement()
		$Player.position = $Spawns/ForestWake.position
		# Easy way to turn around
		$Player.move_to_absolute(Vector2(1, 0))
		GlobalFade.fade_in()
		yield(GlobalFade.tween, "tween_completed")
		$Player.enable_movement()