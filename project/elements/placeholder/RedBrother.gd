extends Node2D

onready var size

signal interaction_finished

func _ready():
	size = $Sprite.texture.get_size()

func interact(player):
	# Simple textbox example
	$Textbox.prepare_and_emit_text("Red Brother", ["Want to try a puzzle?"])
	player.set_process_input(false)
	yield($Textbox, "textbox_done")
	# Simple choicebox example
	$ChoiceBox.prepare_and_emit_options("I know", "Nah")
	var choice = yield($ChoiceBox, "choicebox_done")
	if (choice == 1):
		$Textbox.prepare_and_emit_text("Red Brother", ["Let's go then."])
		yield($Textbox, "textbox_done")
		Global.transition_to_puzzle(get_parent().get_parent(), "TestPuzzle")
	elif (choice == 2):
		$Textbox.prepare_and_emit_text("Red Brother", ["Don't sweat it."])
		yield($Textbox, "textbox_done")
	player.set_process_input(true)
	emit_signal("interaction_finished")