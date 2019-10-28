extends Control

# Normalmente, o padrão é false
var puzzle_solved = false

var puzzle_intro_text = ["PUZZLE TIME BABY!"]

signal puzzle_solved

var total_time = 0

func _ready():
	disable_parts()
	set_process(false)
	
	$TotalTimer.set_wait_time($Rope1.rope_duration + $Rope2.rope_duration)
	$TotalTimer.start()
	$TotalTimer.set_paused(true)
	$Rope1.connect("rope_ended", self, "pause_total_timer")
	$Rope2.connect("rope_ended", self, "pause_total_timer")
	
	
	GlobalFade.fade_in()
	yield(GlobalFade.tween, "tween_completed")
	$Intro/Introbox.prepare_and_emit_text("", puzzle_intro_text, "pop_in_center", "pop_out")
	yield($Intro/Introbox, "textbox_done")
	$Intro/Blur.hide()
	set_process(true)
	enable_parts()
	
func _process(delta):
	var rope_number = 0
	if (self.has_node("Rope1")):
		rope_number += 1
		if ($Rope1.fire_started):
			$TotalTimer.set_paused(false)
	if (self.has_node("Rope2")):
		rope_number += 1
		if ($Rope2.fire_started):
			$TotalTimer.set_paused(false)
	
	total_time = floor($TotalTimer.wait_time - $TotalTimer.time_left)
	$TotalTime.set_text(str("Tempo: ", total_time, " minutos"))

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
	if (self.has_node("Rope1")):
		$Rope1.disable()
	if (self.has_node("Rope2")):
		$Rope2.disable()
	$BlurZ0/SubmitBox/SubmitButton.hide()

func pause_total_timer():
	$TotalTimer.set_paused(true)