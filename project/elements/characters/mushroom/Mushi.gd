extends KinematicBody2D

onready var size

signal interaction_finished

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents
	if (!flags.wb_puzzle):
		$AnimationPlayer.play("panic")

func interact(player):
	if (!flags.wb_puzzle):
#		if (player.position.x > self.position.x):
#			self.set_scale(Vector2(-abs(self.scale.x), self.scale.y))
#		else:
#			self.set_scale(Vector2(abs(self.scale.x), self.scale.y))
		player.disable_movement()
		$Textbox.prepare_and_emit_text("Mushi", ["Eu não acredito! Eu não acredito que ele esqueceu de tomar o remédio denovo!"])
		yield($Textbox, "textbox_done")
		$Textbox.prepare_and_emit_text("Gasa", ["O que aconteceu, Mushi?"])
		yield($Textbox, "textbox_done")
		$Textbox.prepare_and_emit_text("Mushi", ["Esse tolo do meu irmão, Shimmi, esqueceu de tomar o remédio de pressão dele! E ainda por cima, ele trouxe para o poço apenas baldes de 3 litros, e 5 litros!", "Eu preciso diluir esse remédio em exatamente 4 litros de água! Como eu vou fazer isso agora?"])
		yield($Textbox, "textbox_done")
		$ThoughtBox.prepare_and_emit_text("Shell", ["...Meio estranho ele precisar de remédios, mas..."])
		yield($ThoughtBox, "textbox_done")
		player.get_node("Sprite").play("bark")
		#Add barking noise
		yield(player.get_node("Sprite"), "animation_finished")
		player.get_node("Sprite").set_animation("idle")
		$Textbox.prepare_and_emit_text("Gasa", [str("Oh... você quer ajudar, ", Global.player_name, "? Certo, vamos ver o que conseguimos fazer, então, Mushi.")])
		yield($Textbox, "textbox_done")
		
		# Transition to puzzle here.
		player.enable_movement()
