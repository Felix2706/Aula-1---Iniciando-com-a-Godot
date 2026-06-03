extends Area2D
@onready var player: CharacterBody2D = $Player


signal powerup_speed
# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		var velocidade_original = body.SPEED
		powerup_speed.emit(body)  
		$Sprite2D.visible = false
		$CollisionShape2D.set_deferred("disabled", true)
		$particulas.emitting = true
		
		body.SPEED += 400
		await $particulas.finished
		await get_tree().create_timer(5.0).timeout
		body.SPEED = velocidade_original
		queue_free()
