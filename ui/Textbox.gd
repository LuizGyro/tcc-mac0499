extends Control

const sample_text = ["Oi, meu nome é Haxixe. Você quer ser meu amiguinho? Eu adoro comer pastel. E jogar Smash. Venha ser meu amiguinho!", "É isso ai galera, chegamos na terça-feira."]

var player_action = false

func _ready():
	set_process_input(true)

func _input(event):
	if (event.is_action("touch")):
		player_action = true

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
		$Text.set_text(string.substr(0, c))
		yield($TextTimer, "timeout")
		if player_action:
			break
	
	if player_action:
		$Text.set_text(string)
		yield($TextTimer, "timeout")
	
	player_action = false
	$CanvasLayer/Arrow/AnimationPlayer.play("Blink")
	while(!player_action):
		pass
	$CanvasLayer/Arrow.hide()
	
	# Possibly play fadeout animation here
	
	queue_free()
	
	
	
# Same as before, but recieves array of strings
func show_multiple_text(s_arr):
	pass
	
	