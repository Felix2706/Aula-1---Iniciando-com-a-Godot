extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	var tween = create_tween().set_loops()
	tween.tween_property($Sprite2D, "position:y", -5.0, 0.45).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Sprite2D, "position:y", 5.0, 0.45).set_ease(Tween.EASE_IN_OUT)

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	GameManager.adicionar_moeda()
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$particulas.emitting = true
	await $particulas.finished
	queue_free()
