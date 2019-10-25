extends Line2D

var fire_started = false

var rope_duration = 60

var time = 0

func _ready():
	$Timer.wait_time = rope_duration
	$BottomFire.position = get_point_position(1)

func _on_TopFire_Button_pressed():
	$TopFire.animation = "burn"
	$TopFire/Tween.interpolate_property($TopFire, "position", $TopFire.position, self.get_point_position(1), rope_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$TopFire/Tween.start()
	if (!fire_started):
		fire_started = true
		$Timer.start()

func _on_BottomFire_Button_pressed():
	$BottomFire.animation = "burn"
	$BottomFire/Tween.interpolate_property($BottomFire, "position", $BottomFire.position, self.get_point_position(0), rope_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$BottomFire/Tween.start()
	if (!fire_started):
		fire_started = true
		$Timer.start()


func _on_Area2D_area_entered(area):
	$Timer.set_paused(true)
	time = $Timer.wait_time - $Timer.time_left
	print(time)
	queue_free()
