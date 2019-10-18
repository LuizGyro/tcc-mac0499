extends Node2D

# This is the map the player is coming from
var source_name = "none"
var T1_cutscene_dialog_1 = ["...Aquilo é um pato com um capacete? Eu estou sonhando?",
						"Acho que eu vou tentar falar com ele..."]
var T1_cutscene_dialog_2 = ["Eu... lati? E o pato só me ignorou...",
						"Que sonho estranho... eu vou voltar para onde eu acordei, e voltar a dormir."]
var T1_cutscene_dialog_3 = ["Ah, então ele está aqui. Vamos conversar com ele. Deixa que eu te ajudo!"]
var T1_cutscene_dialog_4 = ["EI! Duco! Faça um favor e venha aqui, por favor!"]

var explore_counter = 0

var cutscene_walk_counter = 0
signal cutscene_walk_end

func _ready():
	set_process(false)
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
		
func _process(delta):
	if (cutscene_walk_counter < 60):
		$Player.move_to_absolute(Vector2(1, 0))
		cutscene_walk_counter += 1
	else:
		emit_signal("cutscene_walk_end")
		set_process(false)
		


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
	elif !flags.fm_second_cutscene:
		if (body.get_name().to_lower() == "player"):
			body.disable_movement()
			body.get_node("Sprite").set_animation("idle")
			$Triggers/T1/Textbox.prepare_and_emit_text("Gasa", T1_cutscene_dialog_3)
			yield($Triggers/T1/Textbox, "textbox_done")
			set_process(true)
			body.get_node("Sprite").set_animation("walk")
			yield(self, "cutscene_walk_end")
			body.get_node("Sprite").set_animation("idle")
			$Triggers/T1/Textbox.prepare_and_emit_text("Gasa", T1_cutscene_dialog_4)
			yield($Triggers/T1/Textbox, "textbox_done")
			$Duco/AnimationPlayer.stop()
			$Duco.adjust_position_to_sprite()
			$Duco/Sprite.set_scale(Vector2(abs($Duco/Sprite.scale.x), $Duco/Sprite.scale.y))
			$Triggers/T1/Tween.interpolate_property($Duco, "position", $Duco.position, Vector2(752, $Duco.position.y), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Triggers/T1/Tween.start()
			yield($Triggers/T1/Tween, "tween_completed")
			$Duco/Sprite.set_animation("walk")
			$Triggers/T1/Tween.interpolate_property($Duco, "position", $Duco.position, Vector2(700, $Duco.position.y), 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Triggers/T1/Tween.start()
			yield($Triggers/T1/Tween, "tween_completed")
			$Duco/Sprite.set_animation("idle")
			body.enable_movement()
			
		