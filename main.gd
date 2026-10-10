extends Node

func _ready() -> void:
	print("=== Horn Clause Engine Tests ===")
	test_horn_engine()
	
	print("\n=== Intent Engine Tests ===")
	test_intent_engine()
	
	print("\n=== Combined NLP + Horn Query ===")
	test_combined()

func test_horn_engine() -> void:
	var engine := HornEngine.new()
	
	engine.add_fact("item", ["item_1"])
	engine.add_fact("color", ["item_1", "red"])
	engine.add_fact("stored_item", ["item_1", "storage_a"])
	engine.add_fact("location", ["storage_a", "warehouse"])
	
	engine.add_rule(
		{"pred": "in_warehouse", "args": ["?X"]},
		[
			{"pred": "stored_item", "args": ["?X", "?S"]},
			{"pred": "location", "args": ["?S", "warehouse"]}
		]
	)
	
	var results := engine.query({"pred": "in_warehouse", "args": ["?X"]})
	
	for answer in results:
		print("Proof substitution: ", answer)
		print("Resolved item: ", engine.walk("?X", answer))
	
	var multi_results := engine.solve([
		{"pred": "color", "args": ["?X", "red"]},
		{"pred": "in_warehouse", "args": ["?X"]}
	])
	
	print("Multi-goal results count: ", multi_results.size())
	for answer in multi_results:
		print("Red in warehouse: ", engine.walk("?X", answer))

func test_intent_engine() -> void:
	var engine := IntentEngine.new()
	var action_handlers := ActionHandlers.new()
	var intent_registry := IntentRegistry.new()
	
	add_child(engine)
	add_child(action_handlers)
	add_child(intent_registry)
	
	engine.configure(action_handlers)
	intent_registry.install(engine)
	
	test_utterance(engine, "Show me the inventory")
	test_utterance(engine, "Go left")
	test_utterance(engine, "Do something unknown")
	test_utterance(engine, "Cancel")

func test_utterance(engine: IntentEngine, text: String) -> void:
	var intent := engine.resolve(text)
	print("Resolution: ", intent)
	
	if intent["status"] == "matched":
		var result: Variant = engine.dispatch(intent)
		print("Execution result: ", result)

func test_combined() -> void:
	var engine := HornEngine.new()
	engine.add_fact("item", ["item_1"])
	engine.add_fact("color", ["item_1", "red"])
	engine.add_fact("stored_item", ["item_1", "storage_a"])
	engine.add_fact("location", ["storage_a", "warehouse"])
	
	engine.add_rule(
		{"pred": "in_warehouse", "args": ["?X"]},
		[
			{"pred": "stored_item", "args": ["?X", "?S"]},
			{"pred": "location", "args": ["?S", "warehouse"]}
		]
	)
	
	var goals := [
		{"pred": "color", "args": ["?X", "red"]},
		{"pred": "in_warehouse", "args": ["?X"]}
	]
	
	var results := engine.solve(goals)
	print("Combined query results:")
	for answer in results:
		print("  Found: ", engine.walk("?X", answer))
