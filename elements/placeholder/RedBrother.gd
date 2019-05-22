extends Node2D

onready var size

signal interaction_finished

func _ready():
	size = $Sprite.texture.get_size()

func interact(player):
	$Textbox.prepare_and_emit_text("Red Brother", ["You did it.", "Very nice."])
	player.set_process_input(false)
	yield($Textbox, "textbox_done")
	player.set_process_input(true)
	emit_signal("interaction_finished")