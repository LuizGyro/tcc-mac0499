extends Line2D

var top_fire_started = false
var bottom_fire_started = false
var fire_started = false

export (int) var rope_duration = 60

var time = 0

signal rope_ended

func _ready():
	$Timer.wait_time = rope_duration
	$BottomFire.position = get_point_position(1)
	
	$TopFire.scale *= self.width / 10
	$BottomFire.scale *= self.width / 10

func _on_TopFire_Button_pressed():
	if (top_fire_started):
		return
	top_fire_started = true
	$TopFire.animation = "burn"
	$TopFire/Tween.interpolate_property($TopFire, "position", $TopFire.position, self.get_point_position(1), rope_duration, Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	$TopFire/Tween.start()
	if (!fire_started):
		fire_started = true
		$Timer.start()

func _on_BottomFire_Button_pressed():
	if (bottom_fire_started):
		return
	bottom_fire_started = true
	$BottomFire.animation = "burn"
	$BottomFire/Tween.interpolate_property($BottomFire, "position", $BottomFire.position, self.get_point_position(0), rope_duration, Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	$BottomFire/Tween.start()
	if (!fire_started):
		fire_started = true
		$Timer.start()


func _on_Area2D_area_entered(area):
	$Timer.set_paused(true)
	time = $Timer.wait_time - $Timer.time_left
	emit_signal("rope_ended")
	queue_free()

func get_elapsed_time():
	if ($Timer.is_stopped()):
		return 0
	return ($Timer.wait_time - $Timer.time_left)
	
func disable():
	$TopFire/Button.hide()
	$BottomFire/Button.hide()

func enable():
	$TopFire/Button.show()
	$BottomFire/Button.show()