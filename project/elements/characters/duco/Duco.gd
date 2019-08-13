extends KinematicBody2D

onready var size

signal interaction_finished

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents
	
func adjust_position_to_sprite():
	pass

func interact(player):
	pass
