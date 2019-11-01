extends Control

# Normalmente, o padrão é false
var puzzle_solved = false

var puzzle_intro_text = ["COIN PUZZLE TIME"]

signal puzzle_solved

var player_turn = true

var coin_n = 1
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
		

func place_coin(p=null):
	disable_parts()
	var c_scene = load(coin_scene)
	var new_coin = c_scene.instance()
	if (p == null):
		new_coin.position = $PotentialCoin.position
	else:
		new_coin.position = p
	if (!player_turn):
		new_coin.get_node("Sprite").set_texture(load("res://assets/puzzles/coins2.png"))
	new_coin.set_name(str(coin_n))
	coin_n += 1
	$Coins.add_child(new_coin)
	
	if (player_turn):
		player_turn = false
		cpu_turn()
	else:
		player_turn = true
		enable_parts()
	
	if (game_ended()):
		finish_game()

func cpu_turn():
	$ThinkTimer.start()
	yield($ThinkTimer, "timeout")
	cpu_check_and_place("random")
	
func cpu_check_and_place(mode):
	# This check should be inside, to determine p
	if (mode == "random"):
		var p
		var possible = false
		var check_n
		# Now check for existing collisions
		while (!possible):
			p = cpu_choose_random()
			check_n = 0
			for coin in $Coins.get_children():
				# Se a distancia dos raios é maior do que a soma dos raios
				if (coin.position.distance_to(p) < 140):
					break
				else:
					check_n += 1
			if (check_n == $Coins.get_child_count()):
				possible = true
		place_coin(p)
		
		

func cpu_choose_random():
	var a = randi() % 1920
	var b = randi() % 1080
	# Big radius (460) minus coin radius (75)
	while (pow((960 - a), 2) + pow((540 - b), 2) > pow(390, 2)):
		a = randi() % 1920
		b = randi() % 1080
	return Vector2(a, b)
		
# This function checks table state, to see if there is any space left for
# further coins. If not, call finish_game.
func game_ended():
	for a in range (480, 1440):
		for b in range (0, 1000):
			# Se pontos dentro da mesa, e pode ser uma moeda nova
			if (pow((960 - a), 2) + pow((540 - b), 2) < pow(390, 2)):
				var check_n
				# Now check for existing collisions
				var p = Vector2(a, b)
				check_n = 0
				for coin in $Coins.get_children():
					# Se a distancia dos raios é maior do que a soma dos raios
					if (coin.position.distance_to(p) < 140):
						break
					else:
						check_n += 1
				if (check_n == $Coins.get_child_count()):
					return false
	return true

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