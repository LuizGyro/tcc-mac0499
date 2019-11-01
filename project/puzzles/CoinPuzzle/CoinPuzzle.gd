extends Control

# Normalmente, o padrão é false
var puzzle_solved = false

var puzzle_intro_text = ["COIN PUZZLE TIME"]

signal puzzle_solved

var player_turn = true

var coin_scene = "res://puzzles/CoinPuzzle/PuzzleCoin.tscn"

func _ready():
	disable_parts()
	$PotentialCoin.connect("coin_placed", self, "place_coin")
	GlobalFade.fade_in()
	yield(GlobalFade.tween, "tween_completed")
	$Intro/Introbox.prepare_and_emit_text("", puzzle_intro_text, "pop_in_center", "pop_out")
	yield($Intro/Introbox, "textbox_done")
	$Intro/Blur.hide()
	enable_parts()

func finish_game():
	disable_parts()
	check_requirements()
	# Faz a animação da solução correspodente (correto ou errado)
	if (puzzle_solved):
		Global.correct_answer = true
	else:
		Global.correct_answer = false
	GlobalFade.fade_out()
	yield(GlobalFade.tween, "tween_completed")
	emit_signal("puzzle_solved")
	Global.transition_to_overworld()
		

func place_coin():
	disable_parts()
	var c_scene = load(coin_scene)
	var new_coin = c_scene.instance()
	new_coin.position = $PotentialCoin.position
	if (!player_turn):
		new_coin.get_node("Sprite").set_texture(load("res://assets/puzzles/coins2.png"))
	$Coins.add_child(new_coin)
	
	if (player_turn):
		player_turn = false
		cpu_turn()
	else:
		player_turn = true
		enable_parts()

func cpu_turn():
	$ThinkTimer.start()
	yield($ThinkTimer, "timeout")
	for a in range (-960, 960):
		for b in range (-540, 540):
			# Se pontos dentro da mesa
			if (pow((960 - a), 2) + pow((540 - b), 2) < pow(460, 2)):
				print(str("a:", a, " b: ", b))
				$PotentialCoin.position = Vector2(a, b)
				# Se nao tem obstrucoes
				yield(get_tree(), "physics_frame")
				if $PotentialCoin.verify_boundaries():
					print("hey")
					place_coin()
					return
	# If reached here, game has ended
	# finish_game()

# This function checks table state, to see if there is any space left for
# further coins. If not, call finish_game.
func check_state():
	pass

# This function checks the requirements for sucess in the puzzle,
# and returns true if they are met, and false oherwise
func check_requirements():
	if !player_turn:
		puzzle_solved = true
		
func enable_parts():
	$PotentialCoin.set_process_input(true)
	$PotentialCoin.set_physics_process(true)
	
func disable_parts():
	$PotentialCoin.set_process_input(false)
	$PotentialCoin.set_physics_process(false)