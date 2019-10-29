extends Node2D

# This is the map the player is coming from
var source_name = "none"

var C1_cutscene_dialog_1 = ["Chegamos, parceirinho. Sugiro que você dê uma volta, e conheça o pessoal por aqui."]
var C1_cutscene_dialog_2 = ["Conhecer o pessoal? Sinceramente, eu só queria ir para casa..."]
var C1_cutscene_dialog_3 = ["..."]

func _ready():
	if (!flags.fph_first_cutscene):
		$Player.disable_movement()
		$Gasa.position = $Player.position - Vector2(0, 40)
		$Gasa/Sprite.scale.x = abs($Gasa/Sprite.scale.x) * sign($Player/Sprite.scale.x)
		$Cutscenes/C1/Timer.start()
		yield($Cutscenes/C1/Timer, "timeout")
		GlobalFade.fade_in()
		yield(GlobalFade.tween, "tween_completed")
		$Duco/Sprite.set_animation("talk")
		$Cutscenes/Textbox.prepare_and_emit_text("Duco", C1_cutscene_dialog_1)
		yield($Cutscenes/Textbox, "textbox_done")
		$Duco/Sprite.set_animation("idle")
		$Cutscenes/ThoughtBox.prepare_and_emit_text("Shell", C1_cutscene_dialog_2)
		yield($Cutscenes/ThoughtBox, "textbox_done")
		$Cutscenes/Textbox.prepare_and_emit_text("Gasa", C1_cutscene_dialog_3)
		yield($Cutscenes/Textbox, "textbox_done")
		$Player.enable_movement()
		flags.fph_first_cutscene = true
		
	elif (source_name == "ForestPuzzleBottom"):
		$Player.disable_movement()
		$Player.position = $Spawns/ForestPuzzleBottom.position
		# Easy way to turn around
		$Player.move_to_absolute(Vector2(0, -1))
		$Gasa.position = $Player.position - Vector2(0, 40)
		$Gasa/Sprite.scale.x = abs($Gasa/Sprite.scale.x) * sign($Player/Sprite.scale.x)
		GlobalFade.fade_in()
		yield(GlobalFade.tween, "tween_completed")
		$Player.enable_movement()
	elif (source_name == "ForestPuzzleSide"):
		$Player.disable_movement()
		$Player.position = $Spawns/ForestPuzzleSide.position
		# Easy way to turn around
		$Player.move_to_absolute(Vector2(-1, 0))
		$Gasa.position = $Player.position - Vector2(0, 40)
		$Gasa/Sprite.scale.x = abs($Gasa/Sprite.scale.x) * sign($Player/Sprite.scale.x)
		GlobalFade.fade_in()
		yield(GlobalFade.tween, "tween_completed")
		$Player.enable_movement()
	elif (source_name == "TitleScreen"):
		$Player.disable_movement()
		$Player.position = $Spawns/TitleScreen.position
		# Easy way to turn around
		$Player.move_to_absolute(Vector2(-1, 0))
		$Gasa.position = $Player.position - Vector2(0, 40)
		$Gasa/Sprite.scale.x = abs($Gasa/Sprite.scale.x) * sign($Player/Sprite.scale.x)
		GlobalFade.fade_in()
		yield(GlobalFade.tween, "tween_completed")
		$Player.enable_movement()