extends Control

func _ready() -> void:
	var loading_screen_values: Array = GameManager.loading_screen_values[GameManager.current_game]
	
	$Name.text = loading_screen_values[0]
	$Description.text = loading_screen_values[1]
	
	var image = Image.load_from_file(loading_screen_values[2])
	var texture = ImageTexture.create_from_image(image)
	$Image.texture = texture
	pass 
