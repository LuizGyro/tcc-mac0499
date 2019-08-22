extends Node2D

# This is a script for general interactible objects. It works by
# getting the name of the node being called, and search for corresponding
# text on a preset dictionary using the name, lowercased, as a key.

signal interaction_finished

var dialog = {"firsttrunk" : "Este tronco é bastante confortável, por algum motivo...",
			  "dummy" : "dummy" }
			
var size

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents

func interact(player):
	var object_name = self.get_name().to_lower()
	$Textbox.prepare_and_emit_text("", [dialog[object_name]])
	remove_control(player)
	yield($Textbox, "textbox_done")
	restore_control(player)
	emit_signal("interaction_finished")

func remove_control(player):
	if Global.control_mode == Global.ControlModes.virtual_gamepad:
		VirtualGamepad.disable()
	else:
		player.controllable = false

func restore_control(player):
	if Global.control_mode == Global.ControlModes.virtual_gamepad:
		VirtualGamepad.enable()
	else:
		player.controllable = true