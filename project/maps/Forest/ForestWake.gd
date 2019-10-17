extends Node2D

var first_cutscene_dialog_1 = ["...", "...Aonde eu estou?"]
var first_cutscene_dialog_2 = ["Eu estou em uma floresta? Até aonde eu me lembro, eu estava no meu quarto.",
								"...", "Vou dar uma olhada em volta, talvez eu me lembre de algo."]
var second_cutscene_dialog_1 = ["Voltar para a cama e dormir não vai resolver nada. Você sabe disso, não?"]
var second_cutscene_dialog_2 = ["Quem disse isso?"]
var second_cutscene_dialog_3 = ["Você deve ser novo por aqui, certo? Eu vi você tentando falar com o Duco...", "Meu nome é Gasa. Percebo que você tem dificuldade em se comunicar, ainda.", "Me permita te acompanhar. Eu posso te ajudar, se você quiser."]

# This is the map the player is coming from
var source_name = "none"

func _ready():
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
		GlobalFade.fade_in()
		yield(GlobalFade.tween, "tween_completed")
		$Player.enable_movement()


func _on_T1_body_entered(body):
	if flags.fw_first_cutscene and flags.fm_first_cutscene:
		if (body.get_name().to_lower() == "player"):
			body.disable_movement()
			body.get_node("Sprite").set_animation("idle")
			$Cutscene/Textbox.prepare_and_emit_text("???", second_cutscene_dialog_1)
			
