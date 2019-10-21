extends Control

# Normalmente, o padrão é false
var puzzle_solved = false

var puzzle_intro_text = ["Ajude Mushi a obter 4 litros de água no balde grande! O balde grande comporta 5 litros, enquanto o pequeno comporta 3 litros.", "Arraste baldes entre si, ou no poço! No poço, é apenas possível esvaziar completamente um balde, ou preenche-lo completamente.", "Arrastar um balde em outro faz com que seus conteúdos sejam despejados completamente no outro."]

signal puzzle_solved

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
	if get_node("5L").contents == 4:
		puzzle_solved = true
		
func enable_parts():
	$"5L".active = true
	$"3L".active = true
	$BlurZ0/SubmitBox/SubmitButton.show()
	
func disable_parts():
	$"5L".active = false
	$"3L".active = false
	$BlurZ0/SubmitBox/SubmitButton.hide()