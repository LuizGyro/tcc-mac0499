extends KinematicBody2D

onready var size

signal interaction_finished

var pl = get_parent().get_node("Player")

func _ready():
	size = $InteractionBox/CollisionShape2D.shape.extents
	# Only block player before begginer puzzles. Make condition later
	set_physics_process(true)

func _physics_process(delta):
	if (pl != null and !$Tween.is_active()):
		$Tween.interpolate_property(self, "position", self.position, Vector2(self.position.x, pl.position.y), 0.1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		$Tween.start()

func interact(player):
	player.disable_movement()
	$Textbox.prepare_and_emit_text("Domi", ["Ei, ei, ei!! Calma ai campeão. Da para ver na sua cara que você é novo por aqui.", "Para este lado fica a saida da floresta, e as coisas não são tão receptivas quanto aqui. Só posso dar passagem para as pessoas que eu acredito que estão qualificadas."])
	yield($Textbox, "textbox_done")
	player.enable_movement()