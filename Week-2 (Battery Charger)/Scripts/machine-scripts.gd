extends Node2D

@export var max_power: float = 100.0
@export var charge_duration: float = 3.0
@export var required_item: String = "battery"

var current_power: float = 0.0
var is_charging: bool = false
var player_inside: bool = false

@onready var power_label: Label = $Label
@onready var interact_area: Area2D = $"."
@onready var power_bar: ProgressBar = $ProgressBar

signal power_changed(current: float, maximum: float)
signal machine_fully_charged

func _ready() -> void:
	interact_area.body_entered.connect(_on_body_entered)
	interact_area.body_exited.connect(_on_body_exited)
	power_bar.max_value = max_power
	power_bar.value = current_power
	power_bar.visible = false
	_update_label()

func _process(delta: float) -> void:
	if is_charging:
		var charge_per_second: float = max_power / charge_duration
		current_power = min(current_power + charge_per_second * delta, max_power)
		emit_signal("power_changed", current_power, max_power)
		_update_ui()

		if is_fully_charged():
			is_charging = false
			power_bar.visible = false
			emit_signal("machine_fully_charged")
			print("[Machine] ✅ Mesin penuh!")

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_inside = true
	_try_start_charging()

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_inside = false

	# Jika player keluar saat masih charging, kembalikan baterai ke inventori
	if is_charging:
		is_charging = false
		Inventory.add_item(required_item, 1)
		print("[Machine] Player keluar! Baterai dikembalikan ke inventori.")

func _try_start_charging() -> void:
	if is_fully_charged():
		print("[Machine] Mesin sudah penuh!")
		return

	if is_charging:
		return

	if not Inventory.has_item(required_item):
		print("[Machine] Tidak ada baterai di inventori!")
		return

	Inventory.remove_item(required_item, 1)
	is_charging = true
	print("[Machine] Mulai mengisi daya... (%.1f detik)" % charge_duration)

func is_fully_charged() -> bool:
	return current_power >= max_power

func _update_ui() -> void:
	power_bar.value = current_power 
	_update_label()

func _update_label() -> void:
	if power_label:
		power_label.text = "Daya: %.0f / %.0f" % [current_power, max_power]
