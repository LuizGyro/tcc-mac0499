extends Node2D

var first_cutscene_dialog_1 = ["...", "...Aonde eu estou?"]
var first_cutscene_dialog_2 = ["Eu estou em uma floresta? Até aonde eu me lembro, eu estava no meu quarto.",
								"...", "Vou dar uma olhada em volta, talvez eu me lembre de algo."]
var second_cutscene_dialog_1 = ["Voltar para a cama e dormir não vai resolver nada. Você sabe disso, não?"]
var second_cutscene_dialog_2 = ["Quem disse isso?"]
var second_cutscene_dialog_3 = ["Você deve ser novo por aqui, certo? Eu vi você tentando falar com o Duco...", "Meu nome é Gasa. Percebo que você tem dificuldade em se comunicar, ainda.", "Me permita te acompanhar. Eu posso te ajudar, se você quiser."]
var second_cutscene_option_1 = ["Sábia escolha. Por ora, então, vou te acompanhar!"]
var second_cutscene_option_2 = ["Pense bem. Sem mim, você terá muita dificuldade em sair daqui."]

# This is the map the player is coming from
var source_name = "none"

func _ready():
	# To prevent preemptive activation
	$Cutscene/Triggers/T1/CollisionShape2D.disabled = true
	if (!flags.fw_first_cutscene):
		$Player.disable_movement()
		
		$Cutscene/AnimationPlayer.play("fade_in")
		yield($Cutscene/AnimationPlayer, "animation_finished")
		$Cutscene/AnimationPlayer.play("zoom_in")
		yield($Cutscene/AnimationPlayer, "animation_finished")
		
		# Animate eyes blinking before setting idle here
		$Player/Sprite._set_playing(false)
		$Player/Sprite.set_animation("idle")
		$Cutscene/Timer.start()
		yield($Cutscene/Timer, "timeout")
		$Cutscene/Thoughtbox.prepare_and_emit_text(Global.player_name, first_cutscene_dialog_1)
		yield($Cutscene/Thoughtbox, "textbox_done")
		$Cutscene/Timer.start()
		yield($Cutscene/Timer, "timeout")
		$Player.move_to_absolute(Vector2(-1, 0))
		$Cutscene/Timer.start()
		yield($Cutscene/Timer, "timeout")
		$Player.move_to_absolute(Vector2(1, 0))
		$Player/AnimatedLabel/AnimationPlayer.play("?")
		$Cutscene/Thoughtbox.prepare_and_emit_text(Global.player_name, first_cutscene_dialog_2)
		yield($Cutscene/Thoughtbox, "textbox_done")
		$Cutscene/Timer.start()
		yield($Cutscene/Timer, "timeout")
		$Player/Sprite._set_playing(true)
		SoundPlayers.get_node("BGM").stream = load("res://assets/placeholder/Final Fantasy VI_ Awakening Extended.ogg")
		SoundPlayers.get_node("BGM").play()
		$Player.enable_movement()
		flags.fw_first_cutscene = true
	elif (source_name == "ForestMain"):
		$Player.disable_movement()
		$Player.position = $Spawns/ForestMain.position
		$Player/Sprite.set_animation("idle")
		# Easy way to turn around
		$Player.move_to_absolute(Vector2(-1, 0))
		if (flags.fw_second_cutscene):
			$Gasa.active = true
			$Gasa.position = $Player.position - Vector2(0, 40)
			$Gasa/Sprite.scale.x = abs($Gasa/Sprite.scale.x) * sign($Player/Sprite.scale.x)
		GlobalFade.fade_in()
		yield(GlobalFade.tween, "tween_completed")
		$Player.enable_movement()
	$Cutscene/Triggers/T1/CollisionShape2D.disabled = false


func _on_T1_body_entered(body):
	if flags.fw_first_cutscene and flags.fm_first_cutscene and !flags.fw_second_cutscene:
		if (body.get_name().to_lower() == "player"):
			body.disable_movement()
			body.get_node("Sprite").set_animation("idle")
			SoundPlayers.get_node("BGM").stop()
			$Cutscene/Textbox.prepare_and_emit_text("???", second_cutscene_dialog_1)
			yield($Cutscene/Textbox, "textbox_done")
			$Player/AnimatedLabel/AnimationPlayer.play("?")
			$Cutscene/Thoughtbox.prepare_and_emit_text(Global.player_name, second_cutscene_dialog_2)
			yield($Cutscene/Thoughtbox, "textbox_done")
			$Gasa.position.y = $Player.position.y
			$Cutscene/Tween.interpolate_property($Gasa, "position", $Gasa.position, $Player.position - Vector2(50, 0), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			$Cutscene/Tween.start()
			$Player/AnimatedLabel/AnimationPlayer.play("!")
			$Player.move_to_absolute(Vector2(-1, 0))
			yield($Cutscene/Tween, "tween_completed")
			$Cutscene/Textbox.prepare_and_emit_text("Gasa", second_cutscene_dialog_3)
			yield($Cutscene/Textbox, "textbox_done")
			$Cutscene/ChoiceBox.prepare_and_emit_options("Yeah", "Nah")
			var choice = yield($Cutscene/ChoiceBox, "choicebox_done")
			while (choice != 1):
				$Cutscene/Textbox.prepare_and_emit_text("Gasa", second_cutscene_option_2)
				yield($Cutscene/Textbox, "textbox_done")
				$Cutscene/ChoiceBox.prepare_and_emit_options("Aceitar", "Recusar")
				choice = yield($Cutscene/ChoiceBox, "choicebox_done")
			$Cutscene/Textbox.prepare_and_emit_text("Gasa", second_cutscene_option_1)
			yield($Cutscene/Textbox, "textbox_done")
			SoundPlayers.get_node("BGM").play()
			$Player.enable_movement()
			$Gasa.active = true
			flags.fw_second_cutscene = true