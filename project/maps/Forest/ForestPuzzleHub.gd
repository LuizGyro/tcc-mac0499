extends Node2D

# This is the map the player is coming from
var source_name = "none"

func _ready():
	# Make initial cutscene
	
	# This will be inside each for. Check other maps for
	# examples on where to place this.
	$Gasa.position = $Player.position - Vector2(0, 40)
	$Gasa/Sprite.scale.x = abs($Gasa/Sprite.scale.x) * sign($Player/Sprite.scale.x)