extends Node
class_name IntentRegistry

func install(engine: IntentEngine) -> void:
	engine.register_intent(
		"open_inventory",
		[
			"^open my inventory$",
			"^show me the inventory$",
			"^show inventory$"
		],
		"handle_open_inventory",
		100
	)
	
	engine.register_intent(
		"move_left",
		[
			"^move left$",
			"^go left$",
			"^turn left$"
		],
		"handle_move_left",
		90
	)
	
	engine.register_intent(
		"cancel_action",
		[
			"^cancel$",
			"^cancel that action$",
			"^stop what you are doing$"
		],
		"handle_cancel_action",
		110
	)
	
	engine.register_intent(
		"find_red_in_warehouse",
		[
			"^find red items in the warehouse$",
			"^show red items in warehouse$",
			"^find red items in warehouse$"
		],
		"handle_find_red_in_warehouse",
		80
	)
