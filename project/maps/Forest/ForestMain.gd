extends Node2D

# This is the map the player is coming from
var source_name = "none"

var explore_counter = 0

func _ready():
	if (source_name == "ForestWake"):
		$Player.disable_movement()
		$Player.position = $Spawns/ForestWake.position
		# Easy way to turn around
		$Player.move_to_absolute(Vector2(1, 0))
		GlobalFade.fade_in()
		yield(GlobalFade.tween, "tween_completed")
		$Player.enable_movement()


func _on_1_body_entered(body):
	if !flags.fm_first_cutscene:
		pass