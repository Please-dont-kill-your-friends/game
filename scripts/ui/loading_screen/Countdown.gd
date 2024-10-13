extends Label


# Startwert für den Countdown
var countdown_value = 10

func _ready():
	# Initialisiere das Label mit dem Startwert
	text = str(countdown_value)
	
	# Starte die Tween-Animation für den Countdown
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "countdown_value", 0, countdown_value)

func _process(delta):
	# Aktualisiere das Label während der Tween-Animation
	text = str(round(countdown_value))
