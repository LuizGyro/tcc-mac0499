extends KinematicBody2D

onready var size

signal interaction_finished

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents
	$AnimationPlayer.play("search")

func interact(player):
	if (!flags.br_puzzle):
		if (player.position.x > self.position.x):
			self.set_scale(Vector2(-abs(self.scale.x), self.scale.y))
		else:
			self.set_scale(Vector2(abs(self.scale.x), self.scale.y))
		$AnimationPlayer.stop()
		player.disable_movement()
		$Textbox.prepare_and_emit_text("Taki", ["Oh... o que eu vou fazer...?"])
		yield($Textbox, "textbox_done")
		$Textbox.prepare_and_emit_text("Gasa", ["Qual o problema, Taki?"])
		yield($Textbox, "textbox_done")
		$Textbox.prepare_and_emit_text("Taki", ["Eu estou esperando o meu namorado Shimmi aparecer, tinhamos um encontro marcado aqui, daqui a 45 minutos...", "Mas eu não tenho nenhum relógio para medir o tempo! O que eu vou fazer..."])
		yield($Textbox, "textbox_done")
		$Textbox.prepare_and_emit_text("Gasa", [str("Ei, ", Global.player_name, ", tive uma ideia de como podemos ajudá-la, com a ajuda de algumas coisas que eu tenho aqui. O que acha?")])
		yield($Textbox, "textbox_done")
		$ChoiceBox.prepare_and_emit_options("Aceitar", "Recusar")
		var choice = yield($ChoiceBox, "choicebox_done")
		if (choice == 1):
			GlobalFade.fade_out()
			player.big_zoom()
			yield(GlobalFade.tween, "tween_completed")
			yield(player.tween, "tween_completed")
			Global.transition_to_puzzle(get_parent(), "RopePuzzle")
			yield(Global.puzzle_scene, "puzzle_solved")
			player.reset_camera()
			GlobalFade.fade_in()
			yield(GlobalFade.tween, "tween_completed")
			
			if Global.correct_answer:
				$Textbox.prepare_and_emit_text("Taki", ["Muito obrigada! Agora que esperamos o tempo correto das cordas queimarem, ele já deveria estar aqui! Será que aconteceu algo...?"])
				yield($Textbox, "textbox_done")
				PxpBar.gain_exp(15)
				yield(PxpBar, "exp_done")
				flags.br_puzzle = true
			else:
				$Textbox.prepare_and_emit_text("Gasa", [str("Não, ", Global.player_name, ", acho que não é este o tempo que estamos procurando... vamos tentar novamente depois.")])
				yield($Textbox, "textbox_done")
			
			player.enable_movement()
		elif (choice == 2):
			player.enable_movement()
		$AnimationPlayer.play("search")
		
	else:
		if (player.position.x > self.position.x):
			self.set_scale(Vector2(-abs(self.scale.x), self.scale.y))
		else:
			self.set_scale(Vector2(abs(self.scale.x), self.scale.y))
		player.disable_movement()
		$Textbox.prepare_and_emit_text("Taki", ["Espero que o Shimmi esteja bem..."])
		yield($Textbox, "textbox_done")
		player.enable_movement()