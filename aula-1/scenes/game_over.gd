# Arquivo game_over.gd

extends Control

@onready var moedas_label: Label = $CenterContainer/Painel/Margin/VBox/MoedasLabel
@onready var titulo: Label = $CenterContainer/Painel/Margin/VBox/GameOverLabel
@onready var mensagem: Label = $CenterContainer/Painel/Margin/VBox/MensagemLabel

func _ready() -> void:
	moedas_label.text = "Moedas coletadas: %d" % GameManager.moedas
	if GameManager.vidas <= 0:
		mensagem.text = "Suas vidas acabaram..."
	else:
		mensagem.text = "O tempo esgotou!"
	var tween = create_tween()
	titulo.modulate.a = 0.0
	tween.tween_property(titulo, "modulate:a", 1.0, 0.6).set_ease(Tween.EASE_OUT)

func _reiniciar() -> void:
	GameManager.vidas = 3
	GameManager.moedas = 0
	GameManager.speed_boost_ativo = false

func _on_tentar_novamente_button_pressed() -> void:
	_reiniciar()
	get_tree().change_scene_to_file("res://scenes/Level.tscn")

func _on_menu_button_pressed() -> void:
	_reiniciar()
	get_tree().change_scene_to_file("res://scenes/menu_inicial.tscn")
