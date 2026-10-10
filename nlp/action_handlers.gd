extends Node
class_name ActionHandlers

func handle_open_inventory(intent: Dictionary) -> Dictionary:
	return {
		"status": "success",
		"action": "open_inventory"
	}

func handle_move_left(intent: Dictionary) -> Dictionary:
	return {
		"status": "success",
		"action": "move_left"
	}

func handle_cancel_action(intent: Dictionary) -> Dictionary:
	return {
		"status": "success",
		"action": "cancel_action"
	}

func handle_find_red_in_warehouse(intent: Dictionary) -> Dictionary:
	return {
		"status": "success",
		"action": "query_horn",
		"goals": [
			{"pred": "color", "args": ["?X", "red"]},
			{"pred": "in_warehouse", "args": ["?X"]}
		]
	}
