extends KinematicBody2D

onready var size

signal interaction_finished

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents

func interact(player):
	player.disable_movement()
	$Textbox.prepare_and_emit_text("Salvio", ["Parece que você tem passado por muita coisa. Quer contar para mim (salvar o jogo)?"])
	yield($Textbox, "textbox_done")
	$ChoiceBox.prepare_and_emit_options("Sim", "Não")
	var choice = yield($ChoiceBox, "choicebox_done")
	if (choice == 1):
		# Dialogo, animação, etc
		save_game()
		$Textbox.prepare_and_emit_text("Salvio", ["Prontinho. Volte a qualquer momento!"])
		yield($Textbox, "textbox_done")
	elif (choice == 2):
		$Textbox.prepare_and_emit_text("Salvio", ["Sem problemas. Volte a qualquer momento!"])
		yield($Textbox, "textbox_done")
	player.enable_movement()

func save_game():
	var savegame = File.new()
	var savedata = save_data()
	savegame.open("user://savegame.save", File.WRITE)
	savegame.store_line(to_json(savedata))
	print(to_json(savedata))
	savegame.close()
	
func save_data():
	var savedict = {
		map = get_parent().filename,
		
		control_mode = Global.control_mode,
		player_name = Global.player_name,
		pxp = Global.pxp,
		
		flags_values = flags.get_current_values()
		}
		
	return savedict