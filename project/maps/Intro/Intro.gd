extends Control

const intro_text = ["Você se lembra?",
					"Você se lembra de algo?",
					"Você se lembra quem você é?",
					"E, acima de tudo...",
					"Você se lembra quem você era?"]

func _ready():
	VirtualGamepad.disable()
	
	$IntroTimer.start()
	yield($IntroTimer, "timeout")
	$BlackFade/AnimationPlayer.play_backwards("fade_out")
	$BGM.play()
	yield($BlackFade/AnimationPlayer, "animation_finished")
	$Textbox.prepare_and_emit_text("", intro_text, "pop_in", "pop_out")
	for child in $Textbox/CanvasLayer/Boxes.get_children():
		if child.get_name().ends_with("In") or child.get_name().ends_with("Out"):
			child.hide()
	yield($Textbox, "textbox_done")
	$WhiteFade/AnimationPlayer.play("fade_out")