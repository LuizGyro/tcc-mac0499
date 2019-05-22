# Usage: call on element, then yield expecting the option to be returned.
# For usage example, check RedBrother.

extends Control

signal choice_made
signal choicebox_done (c)

var choice

var player_action = false
var waiting_next = false

# Make any customizations here: load portrait, change font, change
# textbox color, etc.
# O que vai precisar provavelmente: se tem animação de entrada/saida da caixa,
# o portrait, o nome do personagem, o texto, se a cena sera invertida (horizontal)
func prepare_and_emit_options(option1="Sim", option2="Não", in_animation="slide_in", out_animation="slide_out"):
	VirtualGamepad.disable()
	
	$CanvasLayer/Boxes/Option1.set_text(option1)
	$CanvasLayer/Boxes/Option2.set_text(option2)
	
	$CanvasLayer/Boxes/AnimationPlayer.play(in_animation)
	yield($CanvasLayer/Boxes/AnimationPlayer, "animation_finished")
		
	yield(self, "choice_made")
		
	$CanvasLayer/Boxes/AnimationPlayer.play(out_animation)
	yield($CanvasLayer/Boxes/AnimationPlayer, "animation_finished")
	
	emit_signal("choicebox_done", choice)
	if (Global.control_mode == Global.ControlModes.virtual_gamepad):
		VirtualGamepad.enable()

func _on_Option1_pressed():
	choice = 1
	emit_signal("choice_made")


func _on_Option2_pressed():
	choice = 2
	emit_signal("choice_made")
