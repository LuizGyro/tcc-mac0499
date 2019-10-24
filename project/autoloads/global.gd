extends Node

enum ControlModes {direct, virtual_gamepad}
var control_mode = ControlModes.direct

var overworld_scene = "dummy"
var puzzle_scene
var correct_answer = false
# This is puzzle experience. If it is used, it should be reduced every time
# the player submits a wrong answer. This is to discourage guessing, and
# reward player thought.
var pxp = 0
var player_name = "Shell"


# This function is used to transition into a puzzle scene,
# from an overworld scene. The overworld scene, represented
# by the "o_scene" variable, is to be saved in global, to be
# later recovered by another function.
# https://docs.godotengine.org/en/3.1/tutorials/misc/change_scenes_manually.html
func transition_to_puzzle(o_scene, puzzle_name):
	overworld_scene = o_scene
	get_tree().get_root().remove_child(o_scene)
	var puzzle_scene_path = str("res://puzzles/", puzzle_name, "/", puzzle_name, ".tscn")
	var p_scene = load(puzzle_scene_path)
	var p_instance = p_scene.instance()
	puzzle_scene = p_instance
	get_tree().get_root().add_child(puzzle_scene)

func transition_to_overworld():
	get_tree().get_root().remove_child(puzzle_scene)
	if (typeof(overworld_scene) == TYPE_OBJECT):
		get_tree().get_root().add_child(overworld_scene)
		# Maybe clear overworld_scene here to not keep it loaded at all times

func transition_to_scene(from, to_path):
	var s_n = from.get_name()
	from.queue_free()
	var to_scene = load(to_path)
	var to_instance = to_scene.instance()
	to_instance.source_name = s_n
	get_tree().get_root().add_child(to_instance)