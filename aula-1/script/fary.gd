extends CharacterBody2D

@export var SPEED = 50.0

var direction = 1
var timer = 0.0

@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("walk")

func _physics_process(delta):
	timer += delta

	if timer >= 5.0:
		direction *= -1
		timer = 0.0

	velocity.x = SPEED * direction
	velocity.y = 0

	anim.flip_h = !direction < 0

	move_and_slide()
