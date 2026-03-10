extends CharacterBody2D

@export var max_speed: float = 400.0
@export var base_speed: float = 50.0
@export var jump_velocity: float = -400.0
@export var acceleration: float = 800.0
@export var friction: float = 1000.0
@export var air_resistance: float = 200.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var anim_speed_min: float = 0.5
@export var anim_speed_max: float = 4.0   

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_time:float = 0.0
var speedup_time: float = 2.5

func _physics_process(delta: float) -> void:
	_gravity(delta)
	_movement_handler(delta)
	_animation_handler()
	move_and_slide()

func _gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func _movement_handler(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		move_time = min(move_time + delta, speedup_time)
		var speedup: float = move_time / speedup_time
		var current_speed: float = lerp(base_speed, max_speed, speedup)
		velocity.x = move_toward(velocity.x, direction * current_speed, acceleration * delta)
		anim.flip_h = direction < 0
	else:
		move_time = 0.0
		var decel := friction if is_on_floor() else air_resistance
		velocity.x = move_toward(velocity.x, 0, decel * delta) 

func _animation_handler() -> void:
	var speed = abs(velocity.x)
	if speed < 1.0:
		anim.play("Idle")
		anim.speed_scale = 1.0
	else:
		anim.play("Run")
		anim.speed_scale = lerp(anim_speed_min, anim_speed_max, speed / max_speed)
