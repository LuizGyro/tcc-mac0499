extends Control


func _ready():
	if Global.control_mode == Global.ControlModes.virtual_gamepad:
		show()


func _on_Up_pressed():
	print("oi")
