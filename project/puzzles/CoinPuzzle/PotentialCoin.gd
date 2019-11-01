extends Node2D

var dragging = false

onready var size

signal coin_placed

func _ready():
	size = $Sprite.texture.get_size()
	set_process_input(true)
	set_physics_process(true)

func _input(event):
	if event.is_action_pressed("touch"):
		dragging = true

	elif event.is_action_released("touch"):
		if (verify_boundaries()):
			emit_signal("coin_placed")
		self.hide()
		dragging = false

func _physics_process(delta):
	if (dragging):
		position = get_viewport().get_mouse_position()
		if (verify_boundaries()):
			self.show()
		else:
			self.hide()

func verify_boundaries():
	var i = false
	var o = false
	for area in $CoinBody.get_overlapping_areas():
		if area.get_name() == "In":
			i = true
		elif area.get_name() == "Out":
			o = true
		else:
			print(area.get_parent().get_name())
			print(area.get_parent().position)
			return false
	
	if (i and !o):
		return true
	else:
		return false