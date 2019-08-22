extends Node2D

func _ready():
	if (!flags.fw_first_cutscene):
		VirtualGamepad.disable()
		
		$Cutscene/AnimationPlayer.play("fade_in")
		yield($Cutscene/AnimationPlayer, "animation_finished")
		$Cutscene/AnimationPlayer.play("zoom_in")
		yield($Cutscene/AnimationPlayer, "animation_finished")
		
		# Animate eyes blinking before setting idle here
		$Player/Sprite._set_playing(false)
		$Cutscene/Timer.start()
		yield($Cutscene/Timer, "timeout")
		$Textbox.prepare_and_emit_text(Global.player_name, "...")
		yield($Textbox, "textbox_done")
		$Player/Sprite.set_animation("idle")
