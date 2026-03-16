extends Area2D

@export var item_name: String = "battery"
@export var amount: int = 1

const PLAYER_GROUP = "player"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(PLAYER_GROUP):
		_pickup()

func _pickup() -> void:
	Inventory.add_item(item_name, amount)
	print("[Battery] Baterai dipungut oleh player!")
	queue_free() 
