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


# This function is used to transition into a puzzle scene,
# from an overworld scene. The overworld scene, represented
# by the "o_scene" variable, is to be saved in global, to be
# later recovered by another function.
# https://docs.godotengine.org/en/3.1/tutorials/misc/change_scenes_manually.html
func transition_to_puzzle(o_scene, puzzle_name):
	overworld_scene = o_scene
	get_tree().get_root().remove_child(o_scene)
	# Load puzzle scene here
	# Testing
	var puzzle_scene_path = "res://puzzles/PuzzleTest/PuzzleTest.tscn"
	var p_scene = load(puzzle_scene_path)
	puzzle_scene = p_scene
	get_tree().get_root().add_child(p_scene)

func transition_to_overworld():
	get_tree().get_root().remove_child(puzzle_scene)
	if (typeof(overworld_scene) == TYPE_OBJECT):
		get_tree().get_root().add_child(overworld_scene) 