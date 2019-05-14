extends Control

const sample_text = ["Oi, meu nome é Haxixe. Você quer ser meu amiguinho? Eu adoro comer pastel. E jogar Smash. Venha ser meu amiguinho!", "É isso ai galera, chegamos na terça-feira."]

var player_action = false
var waiting_next = false

func _ready():
	set_process_input(true)
	show_text(sample_text[0])

func _input(event):
	if (event.is_action("touch")):
		player_action = true
		if (waiting_next):
			$NextTimer.start()

# Make any customizations here: load portrait, change font, change
# textbox color, etc.
# O que vai precisar provavelmente: se tem animação de entrada/saida da caixa,
# o portrait, o nome do personagem, o texto, se a cena sera invertida (horizontal)
func prepare():
	pass
	
# Show text on screen. Recieves single string.
func show_text(string):
	var text_length = string.length()
	for c in text_length:
		$CanvasLayer/Text.set_text(string.substr(0, c))
		$TextTimer.start()
		yield($TextTimer, "timeout")
		if player_action:
			break
	
	if player_action:
		$CanvasLayer/Text.set_text(string)
		$SkipTimer.start()
		yield($SkipTimer, "timeout")
	
	player_action = false
	$CanvasLayer/Arrow/AnimationPlayer.play("Blink")
	# Only activated when waiting for next text
	waiting_next = true
	yield($NextTimer, "timeout")
	$CanvasLayer/Arrow/AnimationPlayer.stop(true)
	$CanvasLayer/Arrow.hide()
	
	# Possibly play fadeout animation here
	
	queue_free()
	
	
	
# Same as before, but recieves array of strings
func show_multiple_text(s_arr):
	pass
	
	