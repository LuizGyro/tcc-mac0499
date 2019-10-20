extends Node2D

# This is the map the player is coming from
var source_name = "none"

func _ready():
	if (source_name == "ForestPuzzleHub"):
		$Player.disable_movement()
		$Player.position = $Spawns/ForestPuzzleHub.position
		# Easy way to turn around
		$Player.move_to_absolute(Vector2(0, 1))
		$Gasa.position = $Player.position - Vector2(0, 40)
		$Gasa/Sprite.scale.x = abs($Gasa/Sprite.scale.x) * sign($Player/Sprite.scale.x)
		GlobalFade.fade_in()
		yield(GlobalFade.tween, "tween_completed")
		$Player.enable_movement()