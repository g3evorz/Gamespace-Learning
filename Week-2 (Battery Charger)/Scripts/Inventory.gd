extends Node

var items: Dictionary = {}

signal inventory_changed(item_name: String, quantity: int)

func add_item(item_name: String, amount: int = 1) -> void:
	if items.has(item_name):
		items[item_name] += amount
	else:
		items[item_name] = amount
	emit_signal("inventory_changed", item_name, items[item_name])
	print("[Inventory] Ditambahkan: %s | Total: %d" % [item_name, items[item_name]])

func remove_item(item_name: String, amount: int = 1) -> bool:
	if not has_item(item_name, amount):
		print("[Inventory] Gagal hapus: %s tidak cukup." % item_name)
		return false
	items[item_name] -= amount
	if items[item_name] <= 0:
		items.erase(item_name)
	emit_signal("inventory_changed", item_name, items.get(item_name, 0))
	print("[Inventory] Dihapus: %s | Sisa: %d" % [item_name, items.get(item_name, 0)])
	return true

func has_item(item_name: String, amount: int = 1) -> bool:
	return items.get(item_name, 0) >= amount

func get_quantity(item_name: String) -> int:
	return items.get(item_name, 0)
