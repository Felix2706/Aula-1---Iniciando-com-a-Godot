extends Area2D

const DURACAO := 5.0
const BONUS_SPEED := 150.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	var tween = create_tween().set_loops()
	tween.tween_property($Sprite2D, "modulate:a", 0.6, 0.35)
	tween.tween_property($Sprite2D, "modulate:a", 1.0, 0.35)

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player" or GameManager.speed_boost_ativo:
		return

	var velocidade_original = body.SPEED
	GameManager.speed_boost_ativo = true
	GameManager.speed_boost_mudou.emit(true)

	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$particulas.emitting = true

	body.SPEED += BONUS_SPEED
	await $particulas.finished
	await get_tree().create_timer(DURACAO).timeout

	if is_instance_valid(body):
		body.SPEED = velocidade_original
	GameManager.speed_boost_ativo = false
	GameManager.speed_boost_mudou.emit(false)
	queue_free()
