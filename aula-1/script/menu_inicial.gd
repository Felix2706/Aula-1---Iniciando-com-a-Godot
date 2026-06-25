# Arquivo menu_inicial.gd

extends Control

# Carrega a cena do jogo antecipadamente — se der erro, aparece no editor
const LEVEL := preload("res://scenes/Level.tscn")

func _ready() -> void:
	var titulo := find_child("TituloJogoLabel", true, false) as Label
	if titulo:
		var tween = create_tween().set_loops()
		tween.tween_property(titulo, "modulate:a", 0.82, 1.4).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(titulo, "modulate:a", 1.0, 1.4).set_ease(Tween.EASE_IN_OUT)

func _on_jogar_button_pressed() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.vidas = 3
		gm.moedas = 0
		if "speed_boost_ativo" in gm:
			gm.speed_boost_ativo = false

	get_tree().change_scene_to_packed(LEVEL)
