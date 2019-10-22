extends Node

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

func _ready():
	var relevant_entries = []
	for entry in get_property_list():
		if entry.name.find("cutscene") != -1 or entry.name.find("puzzle") != -1:
			relevant_entries.append(entry.name)
	print(relevant_entries)