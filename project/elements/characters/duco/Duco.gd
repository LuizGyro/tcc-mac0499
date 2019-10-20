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
	if (flags.fph_first_cutscene):
		if (player.position.x > self.position.x):
			self.set_scale(Vector2(-abs(self.scale.x), self.scale.y))
		else:
			self.set_scale(Vector2(abs(self.scale.x), self.scale.y))
			
		player.disable_movement()
		$Sprite.set_animation("talk")
		$Textbox.prepare_and_emit_text("Duco", ["E ai, esta se acostumando? Converse com todos, são gente muito simpatica."])
		yield($Textbox, "textbox_done")
		$Sprite.set_animation("idle")
		player.enable_movement()
