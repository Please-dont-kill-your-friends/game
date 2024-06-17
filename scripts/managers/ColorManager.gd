extends Node

enum COLORS {
	RED = 0,
	ORANGE = 1,
	YELLOW = 2,
	GREEN = 3,
	BLUE = 4,
	VIOLET = 5
}

var _colors: Array[Color] = [
	Color(0.99, 0.2, 0.2), 
	Color(0.99, 0.6, 0.18), 
	Color(1, 0.92, 0.2), 
	Color(0.54, 0.99, 0.52), 
	Color(0.4, 0.64, 0.97), 
	Color(0.48, 0.32, 0.88)
]

var used_colors: Array[COLORS] = []

func get_color(color: int) -> Color:
	return _colors[color]

func get_unique_color() -> COLORS:
	var color: COLORS
	while true:
		color = randi() % ColorManager.COLORS.size()
		if color not in used_colors: break
	used_colors.append(color)
	return color
