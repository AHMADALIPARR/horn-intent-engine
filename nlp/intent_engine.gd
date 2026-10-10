extends Node
class_name IntentEngine

var registry: Array[Dictionary] = []
var handlers: Object

func configure(handler_object: Object) -> void:
	handlers = handler_object

func register_intent(
	intent_id: String,
	patterns: Array[String],
	handler_name: String,
	priority: int = 0
) -> bool:
	if handlers == null:
		return false
	
	if not handlers.has_method(handler_name):
		push_error("Unknown handler: " + handler_name)
		return false
	
	registry.append({
		"id": intent_id,
		"patterns": patterns,
		"handler": handler_name,
		"priority": priority
	})
	
	registry.sort_custom(
		func(a: Dictionary, b: Dictionary) -> bool:
			return a["priority"] > b["priority"]
	)
	
	return true

func resolve(utterance: String) -> Dictionary:
	var normalized := utterance.strip_edges().to_lower()
	
	for intent in registry:
		for pattern in intent["patterns"]:
			var regex := RegEx.new()
			
			if regex.compile(pattern) != OK:
				continue
			
			var result := regex.search(normalized)
			
			if result != null:
				return {
					"status": "matched",
					"intent": intent["id"],
					"handler": intent["handler"],
					"matched_text": result.get_string(),
					"captures": result.strings,
					"source": utterance
				}
	
	return {
		"status": "unmatched",
		"source": utterance
	}

func dispatch(intent_result: Dictionary) -> Variant:
	if intent_result.get("status") != "matched":
		return {
			"status": "rejected",
			"reason": "No matching intent"
		}
	
	var handler_name: String = intent_result["handler"]
	
	if handlers == null or not handlers.has_method(handler_name):
		return {
			"status": "rejected",
			"reason": "Handler unavailable"
		}
	
	return handlers.callv(handler_name, [intent_result])
