extends KinematicBody2D

onready var size

var transition_state_1 = false

signal interaction_finished

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents
	if (!flags.wb_puzzle):
		$AnimationPlayer.play("panic")

func interact(player):
	if (!flags.wb_puzzle):
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
		
		GlobalFade.fade_out()
		player.big_zoom()
		yield(GlobalFade.tween, "tween_completed")
		yield(player.tween, "tween_completed")
		Global.transition_to_puzzle(get_parent().get_parent(), "WaterBucketPuzzle")
		yield(Global.puzzle_scene, "puzzle_solved")
		player.reset_camera()
		GlobalFade.fade_in()
		yield(GlobalFade.tween, "tween_completed")
		
		if Global.correct_answer:
			$Textbox.prepare_and_emit_text("Mushi", ["É isso! Vou só adicionar o remédio, e já administro para o Shimmi! Muito obrigado!"])
			yield($Textbox, "textbox_done")
			PxpBar.gain_exp(15)
			yield(PxpBar, "exp_done")
			transition_state_1 = true
			flags.wb_puzzle = true
		else:
			$Textbox.prepare_and_emit_text("Mushi", ["Não, não, não!! Foi a medida errada!"])
			yield($Textbox, "textbox_done")
			$ThoughtBox.prepare_and_emit_text("Shell", ["Realmente... vou tentar novamente depois..."])
			yield($ThoughtBox, "textbox_done")
		
		player.enable_movement()
	elif (transition_state_1):
		if (player.position.x > self.position.x):
			self.set_scale(Vector2(-abs(self.scale.x), self.scale.y))
		else:
			self.set_scale(Vector2(abs(self.scale.x), self.scale.y))
		player.disable_movement()
		$Textbox.prepare_and_emit_text("Mushi", ["Estou misturando o remédio, logo administro para o Shimmi. Muito obrigado novamente!"])
		yield($Textbox, "textbox_done")
		player.enable_movement()
	else:
		if (player.position.x > self.position.x):
			self.set_scale(Vector2(-abs(self.scale.x), self.scale.y))
		else:
			self.set_scale(Vector2(abs(self.scale.x), self.scale.y))
		player.disable_movement()
		$Textbox.prepare_and_emit_text("Mushi", ["Como você pode ver, o Shimmi está melhor, graças a vocês!"])
		yield($Textbox, "textbox_done")
		player.enable_movement()