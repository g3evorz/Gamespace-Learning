extends Area2D

@export var speed = 400.0
@export var range_distance = 300.0
@export var rotation_speed = 15.0 
@export var damage = 10

var player = null
var start_position = Vector2.ZERO
var is_returning = false
var direction = Vector2.RIGHT

func _ready():
	start_position = global_position
	player = get_tree().get_first_node_in_group("player")
	
	body_entered.connect(_on_body_entered)

func _process(delta):
	$Sprite2D.rotation += rotation_speed * delta
	if not is_returning:
		move_out(delta)
	else:
		move_back(delta)

func move_out(delta):
	global_position += direction * speed * delta
	
	if global_position.distance_to(start_position) >= range_distance:
		is_returning = true

func move_back(delta):
	if player:
		var dir_to_player = (player.global_position - global_position).normalized()
		global_position += dir_to_player * (speed * 1.2) * delta
		
		if global_position.distance_to(player.global_position) < 20.0:
			queue_free()
			
func _on_body_entered(body):
	print("Bumerang menyentuh: ", body.name) 
	
	if body.is_in_group("enemy"):
		print("Objek ini ada di grup enemy!")
		if body.has_method("take_damage"):
			print("Objek ini punya fungsi take_damage, memberikan damage...")
			body.take_damage(damage)
		else:
			print("ERROR: Objek tidak punya fungsi take_damage!")
