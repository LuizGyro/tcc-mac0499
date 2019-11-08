extends Node

# Array with all flag names
var n_arr = []

# Array with all flag values
var v_arr = []

# ForestWake
var fw_first_cutscene = true
var fw_second_cutscene = true

# ForestMain
var fm_first_cutscene = true
var fm_second_cutscene = true

# ForestPuzzleHub
var fph_first_cutscene = true

# ForestPuzzleBottom
var wb_puzzle = false

# ForestPuzzleSide
var br_puzzle = false
var c_puzzle = false

#func _ready():
#	for entry in get_property_list():
#		if entry.name.find("cutscene") != -1 or entry.name.find("puzzle") != -1:
#			f_arr.append(self.get(entry.name))
#	print(f_arr)

func get_names():
	n_arr.clear()
	for entry in get_property_list():
		if entry.name.find("cutscene") != -1 or entry.name.find("puzzle") != -1:
			n_arr.append(entry.name)
	return n_arr

func get_current_values():
	v_arr.clear()
	for entry in get_property_list():
		if entry.name.find("cutscene") != -1 or entry.name.find("puzzle") != -1:
			# self.get here gets value from entry.name
			v_arr.append(self.get(entry.name))
	return v_arr
	
	
	
	