class_name CustomSlider
extends HSlider

func _on_drag_ended(_value_changed: bool) -> void:
	self.release_focus()

func _on_value_changed(value: float) -> void:
	if not SoundManager.change_slider_player.playing:
		SoundManager.change_slider_player.play()
