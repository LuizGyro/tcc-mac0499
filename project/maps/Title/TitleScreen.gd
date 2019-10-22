extends Control

func _ready():
	VirtualGamepad.disable()
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		$CanvasLayer/MainMenu/Continuar.disabled = true
	else:
		savegame.open("user://savegame.save", File.READ)
		var savedata = {}
		savedata = parse_json(savegame.get_as_text())
		savegame.close()
		
		# Use savedata here to choose default control_mode
		Global.control_mode = savedata.control_mode

func disable_buttons():
	for button in $CanvasLayer/MainMenu.get_children():
		button.disabled = true

func _on_Novo_pressed():
	disable_buttons()
	$CanvasLayer/BlackFade.show()
	$CanvasLayer/BlackFade/AnimationPlayer.play("fade_out")
	yield($CanvasLayer/BlackFade/AnimationPlayer, "animation_finished")
	Global.call_deferred("transition_to_scene", self, "res://maps/Intro/Intro.tscn")


func _on_Continuar_pressed():
	pass # Replace with function body.


func _on_Opes_pressed():
	$CanvasLayer/MainMenu.hide()
	$CanvasLayer/Opt.show()
	adjust_opt_colors()
	

func adjust_opt_colors():
	if (Global.control_mode == Global.ControlModes.direct):
		$CanvasLayer/Opt/Direto.set("custom_colors/font_color", Color("0fff00"))
		$CanvasLayer/Opt/Direto.set("custom_colors/font_color_hover", Color("0fff00"))
		$CanvasLayer/Opt/Direto.set("custom_colors/font_color_pressed", Color("0bc300"))
		$CanvasLayer/Opt/Gamepad.set("custom_colors/font_color", Color("ffffff"))
		$CanvasLayer/Opt/Gamepad.set("custom_colors/font_color_hover", Color("ffffff"))
		$CanvasLayer/Opt/Gamepad.set("custom_colors/font_color_pressed", Color("b1b1b1"))
	else:
		$CanvasLayer/Opt/Gamepad.set("custom_colors/font_color", Color("0fff00"))
		$CanvasLayer/Opt/Gamepad.set("custom_colors/font_color_hover", Color("0fff00"))
		$CanvasLayer/Opt/Gamepad.set("custom_colors/font_color_pressed", Color("0bc300"))
		$CanvasLayer/Opt/Direto.set("custom_colors/font_color", Color("ffffff"))
		$CanvasLayer/Opt/Direto.set("custom_colors/font_color_hover", Color("ffffff"))
		$CanvasLayer/Opt/Direto.set("custom_colors/font_color_pressed", Color("b1b1b1"))

func _on_Direto_pressed():
	Global.control_mode = Global.ControlModes.direct
	adjust_opt_colors()


func _on_Gamepad_pressed():
	Global.control_mode = Global.ControlModes.virtual_gamepad
	adjust_opt_colors()


func _on_Retornar_pressed():
	$CanvasLayer/Opt.hide()
	$CanvasLayer/MainMenu.show()
