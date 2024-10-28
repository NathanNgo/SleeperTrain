extends ParallaxBackground

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_offset -= Vector2(delta * 40, 0)
