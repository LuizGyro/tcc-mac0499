extends KinematicBody2D

onready var size

signal interaction_finished

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents

func interact(player):
	if (!flags.wb_puzzle):
		player.disable_movement()
		$Textbox.prepare_and_emit_text("Gasa", ["...Ele não parece estar respondendo..."])
		yield($Textbox, "textbox_done")
		player.enable_movement()
