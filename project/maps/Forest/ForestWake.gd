extends Node2D

var first_cutscene_dialog_1 = ["...", "...Aonde eu estou?"]
var first_cutscene_dialog_2 = ["Eu estou em uma floresta? Até aonde eu me lembro, eu estava no meu quarto.",
								"...", "Vou dar uma olhada em volta, talvez eu me lembre de algo."]

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
