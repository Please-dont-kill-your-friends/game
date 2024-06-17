extends PlayerController

signal tank_exploded(id: int, sender: CharacterBody2D)
signal shoot_bullet(bullet: CharacterBody2D)

var muzzle_flash_scene: PackedScene = load("res://scenes/games/tanks/MuzzleFlash.tscn")
var bullet_scene: PackedScene = load("res://scenes/games/tanks/Bullet.tscn")
var big_explosion_scene: PackedScene = load("res://scenes/games/tanks/ExplosionBig.tscn")

const SPEED: float = 80.0
const ROT_SPEED: float = 60.0
var rotation_dir = 0
var rotation_deg = 0

func _ready():
	super()
	$TankSprite.modulate = ColorManager.get_color(player.color)
	pass

func _physics_process(delta):
	rotation_degrees += rotation_dir * ROT_SPEED * delta
	move_and_slide()

func _drive(vec: Vector2):
	if vec == Vector2.ZERO:
		velocity = Vector2.ZERO
		rotation_dir = 0
	else:
		if abs(vec.x) > abs(vec.y):
			velocity = Vector2.ZERO
			rotation_dir = sign(vec.x)
		else:
			velocity = Vector2(sign(vec.y), 0) * Vector2(-1, 0)
			rotation_dir = 0
	
	velocity = velocity.rotated(rotation) * SPEED
	pass

func _shoot():
	var muzzle_flash_instance: AnimatedSprite2D = muzzle_flash_scene.instantiate()
	$Muzzle.add_child(muzzle_flash_instance)
	muzzle_flash_instance.play()
	
	var bullet_instance: CharacterBody2D = bullet_scene.instantiate()
	bullet_instance.global_position = $Muzzle.global_position
	bullet_instance.rotation = $Muzzle.global_rotation
	bullet_instance.modulate = ColorManager.get_color(player.color)
	bullet_instance.sender = self
	
	SoundManager.play_audio_at_pos(SoundManager.GAME_AUDIO.TANK_SHOOT, $Muzzle.global_position, get_parent())
	shoot_bullet.emit(bullet_instance)
	pass

func explode(sender: CharacterBody2D):
	var big_explosion_instance: AnimatedSprite2D = big_explosion_scene.instantiate()
	big_explosion_instance.global_position = global_position
	big_explosion_instance.rotation_degrees = randi() % 360
	get_parent().get_parent().add_child(big_explosion_instance)
	
	SoundManager.play_audio_at_pos(SoundManager.GAME_AUDIO.TANK_BIG_EXPLODE, global_position, get_parent())
	queue_free()
	tank_exploded.emit(player.id, sender)
	pass

func _received_vector(vec: Vector2):
	_drive(vec)
	pass

func _received_button_a():
	_create_cooldown_timer()
	_shoot()
	pass

func _create_cooldown_timer():
	var timer: Timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(_on_timer_cooldown_timeout.bind(timer))
	add_child(timer)
	timer.start()
	pass

func _on_timer_cooldown_timeout(timer: Timer):
	timer.queue_free()
	CommunicationManager.server_disable_button_a.rpc_id(player.id, false)
	pass
