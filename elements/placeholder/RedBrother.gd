extends Node2D

onready var size

signal interaction_finished

func _ready():
	size = $Sprite.texture.get_size()

func interact(player):
	$Textbox.prepare_and_emit_text("Red Brother", ["You did it."])
	player.set_process_input(false)
	yield($Textbox, "textbox_done")
	$ChoiceBox.prepare_and_emit_options("I know", "Nah")
	var choice = yield($ChoiceBox, "choicebox_done")
	if (choice == 1):
		$Textbox.prepare_and_emit_text("Red Brother", ["Don't be so full of yourself."])
		yield($Textbox, "textbox_done")
	elif (choice == 2):
		$Textbox.prepare_and_emit_text("Red Brother", ["Don't sweat it."])
		yield($Textbox, "textbox_done")
	player.set_process_input(true)
	emit_signal("interaction_finished")