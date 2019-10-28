extends Control

# Normalmente, o padrão é false
var puzzle_solved = false

var puzzle_intro_text = ["PUZZLE TIME BABY!"]

signal puzzle_solved

var total_time = 0

func _ready():
	disable_parts()
	GlobalFade.fade_in()
	yield(GlobalFade.tween, "tween_completed")
	$Intro/Introbox.prepare_and_emit_text("", puzzle_intro_text, "pop_in_center", "pop_out")
	yield($Intro/Introbox, "textbox_done")
	$Intro/Blur.hide()
	enable_parts()

# Essa função se liga ao SubmitButton, para que transicionemos
# para a tela em que a solução é entregue. Esta pode ser filha
# desta cena mesmo, por conveniencia.
func submit_answer():
	disable_parts()
	$BlurZ0/SubmitBox.hide()
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
		

# This function checks the requirements for sucess in the puzzle,
# and returns true if they are met, and false oherwise
func check_requirements():
	if total_time >= 43 and total_time <= 47:
		puzzle_solved = true
		
func enable_parts():
	$Rope1.enable()
	$Rope2.enable()
	$BlurZ0/SubmitBox/SubmitButton.show()
	
func disable_parts():
	$Rope1.disable()
	$Rope2.disable()
	$BlurZ0/SubmitBox/SubmitButton.hide()