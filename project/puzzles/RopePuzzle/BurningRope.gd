extends Line2D

var time

func _ready():
	$BottomFire.position = get_point_position(1)
	set_physics_process(true)
	
func _physics_process(delta):
	pass
#	self.set_point_position(0, $TopFire.position)
#	self.set_point_position(1, $BottomFire.position)



func _on_TopFire_Button_pressed():
	$TopFire/Tween.interpolate_property($TopFire, "position", $TopFire.position, self.get_point_position(1), 6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$TopFire/Tween.start()

func _on_BottomFire_Button_pressed():
	$BottomFire/Tween.interpolate_property($BottomFire, "position", $BottomFire.position, self.get_point_position(0), 6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$BottomFire/Tween.start()
