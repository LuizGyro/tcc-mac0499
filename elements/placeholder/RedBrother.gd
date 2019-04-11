extends Node2D

onready var size

func _ready():
	size = $Sprite.texture.get_size()

func interact():
	$Interaction.show()
	$Interaction/Timer.start()
	yield($Interaction/Timer, "timeout")
	$Interaction.hide()