extends Node2D

var dragging = false

onready var size

func _ready():
	size = $Sprite.texture.get_size()
	set_process_input(true)
	set_physics_process(true)

func _input(event):
	if event.is_action_pressed("touch") and verify_boundaries():
		self.show()
		dragging = true

	elif event.is_action_released("touch"):
		self.hide()
		dragging = false

func _physics_process(delta):
	if (dragging):
		if (verify_boundaries()):
			self.show()
		else:
			self.hide()
		position = get_viewport().get_mouse_position()

func verify_boundaries():
	var i = false
	var o = false
	for area in $Area2D.get_overlapping_areas():
		if area.get_name() == "In":
			i = true
		elif area.get_name() == "Out":
			o = true
	
	if (i and !o):
		return true
	else:
		return false