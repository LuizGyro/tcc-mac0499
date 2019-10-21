extends KinematicBody2D

onready var size

signal interaction_finished

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents

func interact(player):
	player.disable_movement()
	$Textbox.prepare_and_emit_text("Nopi", ["Um visitante novo! Estou tão animado!!"])
	yield($Textbox, "textbox_done")
	player.enable_movement()