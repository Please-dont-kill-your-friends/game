extends Camera2D

var random_strength: float = 30.0
var shake_fade: float = 5.0
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

var zoom_winner: bool = false
var camera_position: Vector2 = global_position
var default_camera_position: Vector2 = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offset()
	
	if zoom_winner:
		global_position = global_position.lerp(camera_position, 0.05)
		zoom = zoom.lerp(Vector2(5.5, 5.5), 0.01)
	else:
		global_position = camera_position
		zoom = Vector2(1.0, 1.0)
	pass

func apply_shake():
	shake_strength = random_strength
	pass

func zoom_to_winner(winner_pos: Vector2):
	zoom_winner = true
	camera_position = winner_pos
	pass

func zoom_out():
	zoom_winner = false
	camera_position = default_camera_position
	pass

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
