extends Node2D

var dragging = false

onready var size

func _ready():
	size = $Sprite.texture.get_size()
	set_process_input(true)
	set_process(true)

func _input(event):
	if event.is_action_pressed("touch") and clicked_on(self):
		dragging = true

	elif event.is_action_released("touch"):
		dragging = false

func _process(delta):
	if (dragging):
		position = get_viewport().get_mouse_position()

func clicked_on(object):
	var mouse_pos = get_viewport().get_mouse_position()
	var absolute_object_position = object.get_global_transform_with_canvas().origin
	
	var posx = absolute_object_position.x
	var posy = absolute_object_position.y
	var sizex = object.size.x * abs(object.scale.x)
	var sizey = object.size.y * abs(object.scale.y)
	
	var min_x = posx - (sizex/2)
	var min_y = posy - (sizey/2)
	var max_x = posx + (sizex/2)
	var max_y = posy + (sizey/2)
	
	if (mouse_pos.x > min_x and mouse_pos.y > min_y and mouse_pos.x < max_x and mouse_pos.y < max_y):
		return true
