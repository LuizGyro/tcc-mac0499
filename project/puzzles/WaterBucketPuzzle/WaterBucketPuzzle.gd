extends Control

# Normalmente, o padrão é false
var puzzle_solved = false

signal puzzle_solved

func _ready():
	GlobalFade.fade_in()
	yield(GlobalFade.tween, "tween_completed")

# Essa função se liga ao SubmitButton, para que transicionemos
# para a tela em que a solução é entregue. Esta pode ser filha
# desta cena mesmo, por conveniencia.
func submit_answer():
	check_requirements()
	# Faz a animação da solução correspodente (correto ou errado)
	if (puzzle_solved):
		Global.correct_answer = true
		GlobalFade.fade_out()
		yield(GlobalFade.tween, "tween_completed")
		emit_signal("puzzle_solved")
		Global.transition_to_overworld()

# This function checks the requirements for sucess in the puzzle,
# and returns true if they are met, and false oherwise
func check_requirements():
	if $Block/Area2D.get_overlapping_areas().size() > 0:
		puzzle_solved = true