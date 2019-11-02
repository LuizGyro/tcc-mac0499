extends Control

func _ready():
	if Global.plv != 0:
		$CanvasLayer/ProgressBar.min_value = Global.m_exp[Global.plv - 1]
		$CanvasLayer/ProgressBar.max_value = Global.m_exp[Global.plv]
	$CanvasLayer/LvlBox/Label.set_text(str("Lv. ", Global.plv))
	
	#test
	gain_exp(75)

func _on_ProgressBar_value_changed(value):
	if value == Global.m_exp[Global.plv]:
		var pbfg = $CanvasLayer/ProgressBar.get("custom_styles/fg")
		pbfg.set("border_width_right", 10)
		# Play level up animation
		$CanvasLayer/Tween.stop($CanvasLayer/ProgressBar, "value")
		$CanvasLayer/AnimationPlayer.play("level_up")
		yield($CanvasLayer/AnimationPlayer, "animation_finished")
		$CanvasLayer/ProgressBar.min_value = Global.m_exp[Global.plv - 1]
		$CanvasLayer/ProgressBar.max_value = Global.m_exp[Global.plv]
		$CanvasLayer/Tween.resume($CanvasLayer/ProgressBar, "value")
	else:
		var pbfg = $CanvasLayer/ProgressBar.get("custom_styles/fg")
		pbfg.set("border_width_right", 0)

func gain_exp(value):
	$CanvasLayer/AnimationPlayer.play("slide_in")
	yield($CanvasLayer/AnimationPlayer, "animation_finished")
	$CanvasLayer/Tween.interpolate_property($CanvasLayer/ProgressBar, "value", Global.pxp, Global.pxp + value, 2.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$CanvasLayer/Tween.start()
	yield($CanvasLayer/Tween, "tween_completed")
	Global.pxp += value
	$CanvasLayer/AnimationPlayer.play("slide_out")
	yield($CanvasLayer/AnimationPlayer, "animation_finished")

func update_level():
	Global.plv += 1
	$CanvasLayer/LvlBox/Label.set_text(str("Lv. ", Global.plv))