extends RefCounted
class_name HornEngine

var facts: Array = []
var rules: Array = []
var fresh_counter: int = 0

const MAX_DEPTH := 64
const MAX_RESULTS := 100

func add_fact(pred: String, args: Array) -> void:
	facts.append({"pred": pred, "args": args.duplicate(true)})

func add_rule(head: Dictionary, body: Array) -> void:
	rules.append({
		"head": head.duplicate(true),
		"body": body.duplicate(true)
	})

func is_variable(term: Variant) -> bool:
	if not term is String:
		return false
	return term.begins_with("?")

func walk(term: Variant, env: Dictionary) -> Variant:
	var current = term
	var steps := 0
	while is_variable(current) and env.has(current):
		current = env[current]
		steps += 1
		if steps > MAX_DEPTH:
			break
	return current

func unify(a: Variant, b: Variant, env: Dictionary):
	a = walk(a, env)
	b = walk(b, env)
	
	if a == b:
		return env
	
	if is_variable(a):
		var next_env = env.duplicate(true)
		next_env[a] = b
		return next_env
	
	if is_variable(b):
		var next_env = env.duplicate(true)
		next_env[b] = a
		return next_env
	
	if a is Dictionary and b is Dictionary:
		if a.get("pred") != b.get("pred"):
			return null
		return unify(a.get("args", []), b.get("args", []), env)
	
	if a is Array and b is Array:
		if a.size() != b.size():
			return null
		var current_env = env
		for i in range(a.size()):
			current_env = unify(a[i], b[i], current_env)
			if current_env == null:
				return null
		return current_env
	
	return null

func freshen(value: Variant, mapping: Dictionary) -> Variant:
	if is_variable(value):
		if not mapping.has(value):
			fresh_counter += 1
			mapping[value] = "?_v" + str(fresh_counter)
		return mapping[value]
	
	if value is Array:
		var result := []
		for item in value:
			result.append(freshen(item, mapping))
		return result
	
	if value is Dictionary:
		var result := {}
		for key in value:
			result[key] = freshen(value[key], mapping)
		return result
	
	return value

func solve(
	goals: Array,
	env: Dictionary = {},
	depth: int = 0
) -> Array:
	if goals.is_empty():
		return [env]
	
	if depth >= MAX_DEPTH:
		return []
	
	var goal: Dictionary = goals[0]
	var remaining: Array = goals.slice(1)
	var answers: Array = []
	
	# First: match database facts.
	for fact in facts:
		if fact["pred"] != goal["pred"]:
			continue
		
		var next_env = unify(goal, fact, env)
		
		if next_env != null:
			answers.append_array(
				solve(remaining, next_env, depth + 1)
			)
		
		if answers.size() >= MAX_RESULTS:
			return answers.slice(0, MAX_RESULTS)
	
	# Second: prove the goal using Horn clauses.
	for stored_rule in rules:
		var mapping := {}
		var rule = freshen(stored_rule, mapping)
		
		var next_env = unify(goal, rule["head"], env)
		
		if next_env == null:
			continue
		
		var new_goals: Array = rule["body"].duplicate(true)
		new_goals.append_array(remaining)
		
		answers.append_array(
			solve(new_goals, next_env, depth + 1)
		)
		
		if answers.size() >= MAX_RESULTS:
			return answers.slice(0, MAX_RESULTS)
	
	return answers

func query(goal: Dictionary) -> Array:
	return solve([goal])
