extends Node2D

# This is a script for general interactible objects. It works by
# getting the name of the node being called, and search for corresponding
# text on a preset dictionary using the name, lowercased, as a key.

signal interaction_finished

var dialog = {"firsttrunk" : "Este tronco é bastante confortável, por algum motivo...",
			"schoosign" : "Escola e área de recreação acima.",  
			"dummy" : "dummy" }
			
var size

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents

func interact(player):
	var object_name = self.get_name().to_lower()
	$Textbox.prepare_and_emit_text("", [dialog[object_name]])
	player.disable_movement()
	yield($Textbox, "textbox_done")
	player.enable_movement()
	emit_signal("interaction_finished")