extends CharacterBody2D

@export var max_health: int = 30
var current_health: int

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	current_health = max_health
	
	add_to_group("enemy")
	if anim:
		anim.play("Idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()

func take_damage(amount: int) -> void:
	current_health -= amount
	print("Musuh terkena ", amount, " damage! HP tersisa: ", current_health)
	
	modulate = Color(1, 0, 0) 
	await get_tree().create_timer(0.1).timeout 
	modulate = Color(1, 1, 1) 
	
	if current_health <= 0:
		die()

func die() -> void:
	print("Musuh hancur!")
	queue_free()
