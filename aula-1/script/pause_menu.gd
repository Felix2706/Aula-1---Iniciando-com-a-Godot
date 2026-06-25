extends CanvasLayer

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true

func _on_continuar_button_pressed() -> void:
	hide()
	get_tree().paused = false

func _on_menu_principal_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu_inicial.tscn")
