extends Node2D

var first_cutscene_dialog = ["...", "...Aonde eu estou?"]

func _ready():
	if (!flags.fw_first_cutscene):
		VirtualGamepad.disable()
		
		$Cutscene/AnimationPlayer.play("fade_in")
		yield($Cutscene/AnimationPlayer, "animation_finished")
		$Cutscene/AnimationPlayer.play("zoom_in")
		yield($Cutscene/AnimationPlayer, "animation_finished")
		
		# Animate eyes blinking before setting idle here
		$Player/Sprite._set_playing(false)
		$Player/Sprite.set_animation("idle")
		$Cutscene/Timer.start()
		yield($Cutscene/Timer, "timeout")
		$Cutscene/Thoughtbox.prepare_and_emit_text(Global.player_name, first_cutscene_dialog)
		yield($Cutscene/Thoughtbox, "textbox_done")
		$Cutscene/Timer.start()
		yield($Cutscene/Timer, "timeout")
		$Player/Sprite._set_playing(true)
		$BGM.play()
		restore_control()

func restore_control():
	if Global.control_mode == Global.ControlModes.virtual_gamepad:
		VirtualGamepad.enable()
	else:
		$Player.controllable = true
