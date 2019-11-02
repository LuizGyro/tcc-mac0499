extends KinematicBody2D

onready var size

signal interaction_finished

onready var pl = get_parent().get_node("Player")

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents
	# Only block player before begginer puzzles. Make condition later
	set_physics_process(true)

func _physics_process(delta):
	if (pl != null and pl.position.y > 900 and pl.position.y < 1125):
		$Tween.interpolate_property(self, "position", self.position, Vector2(self.position.x, pl.position.y), 0.8, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		$Tween.start()
	else:
		$Tween.stop(self)

func interact(player):
	player.disable_movement()
	$Textbox.prepare_and_emit_text("Domi", ["Ei, ei, ei!! Calma ai campeão. Da para ver na sua cara que você é novo por aqui.", "Para este lado fica a saida da floresta, e as coisas não são tão receptivas quanto aqui. Só posso dar passagem para as pessoas que eu acredito que estão qualificadas.", "Podemos jogar um jogo para ver se você possui o potencial para passar. O que acha?"])
	yield($Textbox, "textbox_done")
	$ThoughtBox.prepare_and_emit_text(Global.player_name, ["Acho que vale a pena ao menos tentar..."])
	yield($ThoughtBox, "textbox_done")
	$Textbox.prepare_and_emit_text("Domi", ["Me parece que você concorda! Vamos lá então."])
	yield($Textbox, "textbox_done")
	GlobalFade.fade_out()
	player.big_zoom()
	yield(GlobalFade.tween, "tween_completed")
	yield(player.tween, "tween_completed")
	Global.transition_to_puzzle(get_parent(), "CoinPuzzle")
	yield(Global.puzzle_scene, "puzzle_solved")
	player.reset_camera()
	GlobalFade.fade_in()
	yield(GlobalFade.tween, "tween_completed")
	
	if Global.correct_answer:
		$Textbox.prepare_and_emit_text("Domi", ["Boa, campeão! Assim que eu gosto de ver!"], "slide_in", "pop_in")
		yield($Textbox, "textbox_done")
		PxpBar.gain_exp(20)
		yield(PxpBar, "exp_done")
		# Check plv to determine dialog (if demo ended, or not yet)
		if (Global.plv >= 1):
			$Textbox.prepare_and_emit_text("Domi", ["Estou convencido! Você pode passar... é o que eu diria, mas infelizmente não tem nada depois daqui. A você que jogou até aqui, muito obrigado por seu tempo! Pode salvar seu progresso, e ficar a vontade. Obrigado, novamente!"], "pop_in", "slide_out")
			yield($Textbox, "textbox_done")
		else:
			$Textbox.prepare_and_emit_text("Domi", ["Mas... ainda não estou convencido. Converse um pouco mais com as pessoas, se familiarize com o ambiente mais. Depois, nós conversamos novamente."], "pop_in", "slide_out")
			yield($Textbox, "textbox_done")
		flags.br_puzzle = true
	else:
		$Textbox.prepare_and_emit_text("Domi", ["É campeão, vai ter que usar a cabecinha para ganhar nesse jogo! Fica a dica: tem uma estratégia que sempre funciona para ganhar."])
		yield($Textbox, "textbox_done")
	
	player.enable_movement()