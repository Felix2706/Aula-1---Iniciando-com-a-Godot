extends CharacterBody2D

@export var SPEED = 80.0
const GRAVITY = 800.0

var direction = 1

@onready var floor_left = $FloorLeft #deve ter o mesmo nome do nó
@onready var floor_right = $FloorRight
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	# Garante que o inimigo terá física para detectar o chão
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Inverte ao detectar borda com o método padrão do Raycast2D is_colliding()
	if not floor_left.is_colliding():
		direction = 1
	if not floor_right.is_colliding():
		direction = -1
		# Aplica velocidade no eixo x
	velocity.x = direction * SPEED
	anim.flip_h = !(direction < 0)
	anim.play("walk")

	move_and_slide()
