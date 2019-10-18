extends KinematicBody2D

var player = null

export var active = true
var timing = false
var following = false

var speed = Vector2(100, 100)
const MAX_SPEED = 400
const ACCEL = 1.3
var direction = Vector2(0, 0)

func _ready():
	player = get_parent().get_node("Player")
	if (player == null):
		queue_free()
	else:
		set_process(true)
		
func _process(delta):
	if (!active):
		return
	if (self.position.distance_to(player.position) > 50 and !following and !timing):
		$FollowTimer.wait_time = randf() * 1.25
		$FollowTimer.start()
		timing = true
		yield($FollowTimer, "timeout")
		following = true
		timing = false
	elif (self.position.distance_to(player.position) < 50):
		following = false
		speed = Vector2(150, 150)
	elif (following):
		direction = (player.position - self.position).normalized()
		if (direction.x > 0):
			$Sprite.set_scale(Vector2(abs(scale.x), scale.y))
		else:
			$Sprite.set_scale(Vector2(-abs(scale.x), scale.y))
		speed = (speed * ACCEL).clamped(MAX_SPEED)
		move_and_slide(direction * speed)
		
		
		
		
		