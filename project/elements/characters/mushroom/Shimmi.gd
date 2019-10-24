extends KinematicBody2D

onready var size

signal interaction_finished

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents
	if (!flags.wb_puzzle):
		$AnimationPlayer.play("lay")
	else:
		$AnimationPlayer.play("stand")

func interact(player):
	if (!flags.wb_puzzle):
		player.disable_movement()
		$Textbox.prepare_and_emit_text("Gasa", ["...Ele não parece estar respondendo..."])
		yield($Textbox, "textbox_done")
		player.enable_movement()
	else:
		if (player.position.x > self.position.x):
			self.set_scale(Vector2(-abs(self.scale.x), self.scale.y))
		else:
			self.set_scale(Vector2(abs(self.scale.x), self.scale.y))
		player.disable_movement()
		$Textbox.prepare_and_emit_text("Shimmi", ["...Obrigado, eu estou me recuperando bem... tenho que parar de ser tão esquecido..."])
		yield($Textbox, "textbox_done")
		player.enable_movement()
