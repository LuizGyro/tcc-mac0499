extends Control

export (int) var duration = 2

onready var tween = $CanvasLayer/Tween

func set_color(c):
	$CanvasLayer/Fade.color = c

func fade_out():
	tween.interpolate_property($CanvasLayer/Fade, "color:a", 0, 1, duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	
func fade_in():
	tween.interpolate_property($CanvasLayer/Fade, "color:a", 1, 0, duration * 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()