extends TextureProgressBar

func _ready() -> void:
	var tween: Tween = self.create_tween().set_loops(20)
	tween.tween_property(self, "radial_initial_angle", 360.0, 2).as_relative()
