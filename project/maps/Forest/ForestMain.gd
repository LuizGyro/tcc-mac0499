extends Node2D

# This is the map the player is coming from
var source_name = "none"
var T1_cutscene_dialog_1 = ["...Aquilo é um pato com um capacete? Eu estou sonhando?",
						"Acho que eu vou tentar falar com ele..."]
var T1_cutscene_dialog_2 = ["Eu... lati? E o pato só me ignorou...",
						"Que sonho estranho... eu vou voltar para onde eu acordei, e voltar a dormir."]

var explore_counter = 0

func _ready():
	if (source_name == "ForestWake"):
		$Player.disable_movement()
		$Player.position = $Spawns/ForestWake.position
		# Easy way to turn around
		$Player.move_to_absolute(Vector2(1, 0))
		if (flags.fw_second_cutscene):
			$Gasa.active = true
			$Gasa.position = $Player.position - Vector2(0, 40)
			$Gasa/Sprite.scale.x = abs($Gasa/Sprite.scale.x) * sign($Player/Sprite.scale.x)
		GlobalFade.fade_in()
		yield(GlobalFade.tween, "tween_completed")
		$Player.enable_movement()


func _on_T1_body_entered(body):
	if !flags.fm_first_cutscene:
		if (body.get_name().to_lower() == "player"):
			body.disable_movement()
			body.get_node("Sprite").set_animation("idle")
			$Triggers/T1/Timer.start()
			yield($Triggers/T1/Timer, "timeout")
			$Triggers/T1/ThoughtBox.prepare_and_emit_text(Global.player_name, T1_cutscene_dialog_1)
			yield($Triggers/T1/ThoughtBox, "textbox_done")
			body.get_node("Sprite").play("bark")
			#Add barking noise
			yield(body.get_node("Sprite"), "animation_finished")
			$Duco/AnimationPlayer.stop()
			$Duco.adjust_position_to_sprite()
			$Duco/AnimatedLabel/AnimationPlayer.play("?")
			yield($Duco/AnimatedLabel/AnimationPlayer, "animation_finished")
			$Duco/AnimationPlayer.play()
			body.get_node("Sprite").set_animation("idle")
			$Triggers/T1/ThoughtBox.prepare_and_emit_text(Global.player_name, T1_cutscene_dialog_2)
			yield($Triggers/T1/ThoughtBox, "textbox_done")
			body.enable_movement()
			flags.fm_first_cutscene = true
			
		
		