extends Control

signal text_done
signal all_text_done
signal textbox_done

const sample_text = ["É isso ai galera, chegamos na terça-feira."]
const sample_text_multiple = ["Oi, meu nome é Haxixe. Você quer ser meu amiguinho? Eu adoro comer pastel. E jogar Smash. Venha ser meu amiguinho!", "É isso ai galera, chegamos na terça-feira."]

var player_action = false
var waiting_next = false
var skippable = true

func _input(event):
	if (event.is_action("touch")):
		player_action = true
		if (waiting_next):
			$NextTimer.start()
			

func reset():
	$CanvasLayer/Boxes/Name.set_text("")
	$CanvasLayer/Boxes/Text.set_text("")

# Make any customizations here: load portrait, change font, change
# textbox color, etc.
# O que vai precisar provavelmente: se tem animação de entrada/saida da caixa,
# o portrait, o nome do personagem, o texto, se a cena sera invertida (horizontal)
func prepare_and_emit_text(char_name, text, in_animation="slide_in", out_animation="slide_out"):
	VirtualGamepad.disable()
	set_process_input(true)
	reset()
	
	$CanvasLayer/Boxes/Name.set_text(char_name)
	
	$CanvasLayer/Boxes/AnimationPlayer.play(in_animation)
	yield($CanvasLayer/Boxes/AnimationPlayer, "animation_finished")
	
	if typeof(text) == TYPE_STRING:
		show_multiple_text([text])
	elif typeof(text) == TYPE_ARRAY:
		show_multiple_text(text)
		
	yield(self, "all_text_done")
		
	$CanvasLayer/Boxes/AnimationPlayer.play(out_animation)
	yield($CanvasLayer/Boxes/AnimationPlayer, "animation_finished")
	
	emit_signal("textbox_done")
	if (Global.control_mode == Global.ControlModes.virtual_gamepad):
		VirtualGamepad.enable()
	
# Show text on screen. Recieves single string.
func show_text(string):
	var text_length = string.length()
	
	# Done for show_multiple_text functionality
	player_action = false
	for c in text_length + 1:
		$CanvasLayer/Boxes/Text.set_text(string.substr(0, c))
		$TextTimer.start()
		yield($TextTimer, "timeout")
		if player_action and skippable:
			break
	
	if player_action and skippable:
		$CanvasLayer/Boxes/Text.set_text(string)
		$SkipTimer.start()
		yield($SkipTimer, "timeout")
	
	player_action = false
	$CanvasLayer/Boxes/Arrow/AnimationPlayer.play("Blink")
	# Only activated when waiting for next text
	waiting_next = true
	yield($NextTimer, "timeout")
	$CanvasLayer/Boxes/Arrow/AnimationPlayer.stop(true)
	$CanvasLayer/Boxes/Arrow.hide()
	
	emit_signal("text_done")
	
	
# Same as before, but recieves array of strings
func show_multiple_text(s_arr):
	for t in s_arr:
		show_text(t)
		yield(self, "text_done")
	emit_signal("all_text_done")