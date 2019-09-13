extends KinematicBody2D

onready var size

signal interaction_finished

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents
	
func adjust_position_to_sprite():
	var sprite_displacement = $Sprite.position
	$Sprite.position = Vector2(0, 0)
	self.position += sprite_displacement

func interact(player):
	pass
