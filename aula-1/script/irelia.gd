extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -550.0

var is_dead = false
var can_die = true

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# PEGA O MARKER2D
@onready var spawn_point = $"../SpawnPoint"

func die():
	if is_dead or not can_die:
		return
	
	is_dead = true
	can_die = false
	
	# Para movimento
	velocity = Vector2.ZERO
	
	# Animação de morte
	animated_sprite_2d.play("die")
	
	# Espera terminar
	await animated_sprite_2d.animation_finished
	
	# TELEPORTA PRO SPAWN
	global_position = spawn_point.global_position
	
	# Reseta velocidade
	velocity = Vector2.ZERO
	
	# Volta pro idle
	animated_sprite_2d.play("idle")
	
	# Espera 1 segundo invencível
	await get_tree().create_timer(1.0).timeout
	
	can_die = true
	is_dead = false

func _physics_process(delta: float) -> void:
	
	# Se morreu trava tudo
	if is_dead:
		return
	
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Movimento
	var direction := Input.get_axis("left", "right")
	
	# Flip
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	# Animações
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("jump")
	
	# Movimento horizontal
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
