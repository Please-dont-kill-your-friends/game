extends CharacterBody2D

var small_explosion_scene: PackedScene = load("res://scenes/games/tanks/ExplosionSmall.tscn")
var sender: CharacterBody2D
const SPEED = 1000.0 

func _ready():
	velocity = Vector2(1, 0).rotated(rotation) * SPEED
	pass

func _physics_process(_delta):
	move_and_slide()
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	if not collision: return
	
	if collision.get_collider().has_method("explode"):
		collision.get_collider().call("explode", sender)
		queue_free()
	else: 
		var small_explosion_instance: AnimatedSprite2D = small_explosion_scene.instantiate()
		small_explosion_instance.global_position = global_position
		small_explosion_instance.rotation_degrees = randi() % 360
		get_parent().add_child(small_explosion_instance)
		
		SoundManager.play_audio_at_pos(SoundManager.GAME_AUDIO.TANK_SMALL_EXPLODE, global_position)
		queue_free()
	pass
