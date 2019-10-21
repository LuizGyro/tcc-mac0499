extends Node2D

var active = true

var dragging = false
var initiator = false

var contents = 0
var original_position
var max_capacity

onready var size

# BLOCK DRAGGING BEHAVIOUR #

func _ready():
	size = $Sprite.texture.get_size()
	original_position = self.position
	max_capacity = get_name()[0].to_int()
	
	set_process_input(true)
	set_process(true)

func _input(event):
	if !active:
		return
	
	if event.is_action_pressed("touch") and clicked_on(self):
		dragging = true
		initiator = true

	elif event.is_action_released("touch"):
		dragging = false
		if $Area2D.get_overlapping_areas().size() > 0:
			var element = $Area2D.get_overlapping_areas()[0].get_parent()
			# Check what kind of body it is
			if (element.get_name() == "Well"):
				if (contents == 0):
					adjust_contents(get_name()[0].to_int())
				else:
					set_contents(0)
			else:
				if (initiator):
					var over = 0
					over = element.adjust_contents(contents)
					element.adjust_sprite()
					set_contents(over)
			set_process_input(false)
			adjust_sprite()
			$Tween.interpolate_property(self, "position", self.position, self.original_position, 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_completed")
			set_process_input(true)
		initiator = false
					
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

# BUCKET BEHAVIOUR #
func adjust_contents(qty):
	var over = 0
	if (contents + qty > max_capacity):
		over = (contents + qty) - max_capacity
		contents = max_capacity
		print(str("Sou o ", get_name()))
		print(over)
	else:
		contents += qty
	$Label.set_text(str(contents, "L"))
	return over

func set_contents(qty):
	contents = qty
	$Label.set_text(str(contents, "L"))
	
func adjust_sprite():
	if contents > 0:
		$Sprite.texture = load("res://assets/puzzles/bucket2.png")
	else:
		$Sprite.texture = load("res://assets/puzzles/bucket.png")