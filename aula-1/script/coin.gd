extends Area2D

signal speed_collected

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		speed_collected.emit(body)  
		$Sprite2D.visible = false
		$CollisionShape2D.set_deferred("disabled", true)
		$particulas.emitting = true
		await $particulas.finished
		queue_free()
