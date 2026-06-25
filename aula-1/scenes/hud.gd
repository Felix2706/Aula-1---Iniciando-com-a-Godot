# Arquivo hud.gd

extends CanvasLayer

@onready var coracoes: HBoxContainer = $Control/PainelVidas/Margin/VBox/HBoxContainer
@onready var barra: ProgressBar = $Control/PainelVidas/Margin/VBox/ProgressBar
@onready var timer_label: Label = $Control/PainelTimer/Margin/TimerLabel
@onready var moedas_label: Label = $Control/PainelMoedas/Margin/HBox/MoedasLabel
@onready var speed_panel: PanelContainer = $Control/PainelSpeed
@onready var painel_moedas: PanelContainer = $Control/PainelMoedas

var texture_cheio = preload("res://assets/coracao_cheio.svg")
var texture_vazio = preload("res://assets/coracao_vazio.svg")
var tempo: float = 90.0

func _ready() -> void:
	var player = get_parent().get_node_or_null("Player")
	if player and player.has_signal("vida_alterada"):
		if not player.vida_alterada.is_connected(_on_player_vida_alterada):
			player.vida_alterada.connect(_on_player_vida_alterada)

	if GameManager.has_signal("moeda_coletada"):
		if not GameManager.moeda_coletada.is_connected(_on_moeda_coletada):
			GameManager.moeda_coletada.connect(_on_moeda_coletada)
	if GameManager.has_signal("speed_boost_mudou"):
		if not GameManager.speed_boost_mudou.is_connected(_on_speed_boost_mudou):
			GameManager.speed_boost_mudou.connect(_on_speed_boost_mudou)

	_on_player_vida_alterada(GameManager.vidas)
	_on_moeda_coletada(GameManager.moedas)
	if timer_label:
		timer_label.text = formatar_tempo(tempo)
	if speed_panel:
		speed_panel.visible = GameManager.speed_boost_ativo

func _process(delta: float) -> void:
	if get_tree().paused or not timer_label:
		return

	if tempo > 0:
		tempo -= delta
		timer_label.text = formatar_tempo(tempo)
		if tempo <= 10.0:
			timer_label.add_theme_color_override("font_color", Color(1.0, 0.45, 0.35))
		else:
			timer_label.add_theme_color_override("font_color", Color(0.95, 0.97, 1.0))
	else:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func atualizar_vidas() -> void:
	_on_player_vida_alterada(GameManager.vidas)

func _on_player_vida_alterada(vida_atual: int) -> void:
	if not coracoes:
		return

	for i in coracoes.get_child_count():
		var coracao = coracoes.get_child(i) as TextureRect
		if coracao:
			coracao.texture = texture_cheio if i < vida_atual else texture_vazio

	if barra:
		var tween = create_tween()
		tween.tween_property(barra, "value", vida_atual, 0.3)

func _on_moeda_coletada(total: int) -> void:
	if moedas_label:
		moedas_label.text = str(total)
	if painel_moedas:
		var tween = create_tween()
		tween.tween_property(painel_moedas, "scale", Vector2(1.12, 1.12), 0.07)
		tween.tween_property(painel_moedas, "scale", Vector2.ONE, 0.12)

func _on_speed_boost_mudou(ativo: bool) -> void:
	if speed_panel:
		speed_panel.visible = ativo

func formatar_tempo(segundos: float) -> String:
	var minutos = int(segundos) / 60
	var segs = int(segundos) % 60
	return "%02d:%02d" % [minutos, segs]
