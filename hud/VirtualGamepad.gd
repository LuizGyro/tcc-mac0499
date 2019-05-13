extends Control

signal up_pressed
signal left_pressed
signal right_pressed
signal down_pressed
signal confirm_pressed
signal up_released
signal left_released
signal right_released
signal down_released

func _ready():
	# Shown by default. Let it be hidden by independent nodes if they so desire.
	if Global.control_mode == Global.ControlModes.virtual_gamepad:
		show()


func _on_Up_pressed():
	emit_signal("up_pressed")


func _on_Right_pressed():
	emit_signal("right_pressed")


func _on_Left_pressed():
	emit_signal("left_pressed")


func _on_Down_pressed():
	emit_signal("down_pressed")


func _on_Confirm_pressed():
	emit_signal("confirm_pressed")


func _on_Up_released():
	emit_signal("up_released")


func _on_Right_released():
	emit_signal("right_released")


func _on_Left_released():
	emit_signal("left_released")


func _on_Down_released():
	emit_signal("down_released")

