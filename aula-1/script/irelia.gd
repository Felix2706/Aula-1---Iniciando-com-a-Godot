extends CharacterBody2D

signal vida_alterada(vida_atual: int)

var JUMP = -400.0
var SPEED = 100.0
var is_dead = false
var can_die = true

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_point: Marker2D = $"../SpawnPoint"
@onready var hud: CanvasLayer = $"../HUD"

func _ready() -> void:
	if GameManager.has_signal("speed_boost_mudou"):
		if not GameManager.speed_boost_mudou.is_connected(_on_speed_boost_mudou):
			GameManager.speed_boost_mudou.connect(_on_speed_boost_mudou)

func _on_speed_boost_mudou(ativo: bool) -> void:
	animated_sprite_2d.modulate = Color(0.75, 0.92, 1.15) if ativo else Color.WHITE

func tomar_dano(dano: int) -> void:
	GameManager.vidas -= dano

	if GameManager.vidas <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		return

	respawn()
	vida_alterada.emit(GameManager.vidas)
	hud.atualizar_vidas()

func respawn() -> void:
	position = spawn_point.position
	velocity = Vector2.ZERO

func die() -> void:
	if is_dead or not can_die:
		return

	is_dead = true
	can_die = false
	velocity = Vector2.ZERO
	animated_sprite_2d.play("die")
	await animated_sprite_2d.animation_finished

	tomar_dano(1)

	if GameManager.vidas > 0:
		animated_sprite_2d.play("idle")
		await get_tree().create_timer(1.0).timeout
		can_die = true
		is_dead = false

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP

	var direction := Input.get_axis("left", "right")

	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("jump")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
