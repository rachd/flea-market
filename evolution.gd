extends Node2D

var rng = RandomNumberGenerator.new()

var max_population = 10
var id = 0

func generate_member():
	var member = []
	#0: sex - 0 for female, 1 for male
	member.push_back(rng.randi_range(0, 1))
	#1: size - mean 1.5, std 0.2; trait is size + (1 * (1 - sex))
	member.push_back(rng.randfn(1.5, 0.2))
	#2: lifespan - mean 80, std 10
	member.push_back(rng.randfn(80, 10))
	#3: obedience - mean 0.2, std. 0.2; trait is categorical <0.4, <0, <0.4, <0.8, <1.2
	member.push_back(rng.randfn(0, 0.2))
	return member
	
func generate_shop_flea():
	var shop_flea = []
	shop_flea.append(rng.randi_range(0, 1))
	shop_flea.append(rng.randf_range(0.5, 2.7))
	shop_flea.append(rng.randf_range(50, 110))
	shop_flea.append(rng.randf_range(-0.8, 0.4))
	return shop_flea
	
func generate_initial_population():
	var population = {}
	var has_male = false
	var has_female = false
	for _p in range(max_population):
		id += 1
		var flea = generate_member()
		if !has_female:
			flea[0] = 0
			has_female = true
		elif !has_male:
			flea[0] = 1
			has_male = true
		population[id] = flea
		
	return population

func _ready():
	rng.randomize()
	var population = generate_initial_population()

func can_reproduce():
	if GameVariables.population.size() == 20:
		return false
	var has_male = false
	var has_female = false
	for p in GameVariables.population.keys():
		var sex = GameVariables.population[p][0]
		if sex == 0:
			has_female = true
		elif sex == 1:
			has_male = true
	return has_female and has_male
	
func reproduce(p):
	var population = p.values()
	var parent_1 = population[rng.randi_range(1, population.size())-1]
	var parent_2 = population[rng.randi_range(1, population.size())-1]
	while parent_2[0] == parent_1[0]:
		parent_2 = population[rng.randi_range(1, population.size())-1]
	
	var new_child = []
	for g in range(parent_1.size()):
		var choice = rng.randi_range(0, 1)
		if g == 0:
			new_child.push_back(choice)
		else:
			if choice == 0:
				new_child.push_back(rng.randfn(parent_1[g], 0.1))
			else:
				new_child.push_back(rng.randfn(parent_2[g], 0.1))
	new_child = _set_bounds(new_child)
	id += 1
	return {"value": new_child, "id": id}
	
func calculate_size(flea):
	return _round_to_dec(flea[1] + (1 * (1 - flea[0])), 2)
	
func calculate_obedience(flea):
	var trait_value = flea[3]
	if trait_value < -0.4:
		return "Very Bad"
	elif trait_value < 0:
		return "Bad"
	elif trait_value < 0.4:
		return "Neutral"
	elif trait_value < 0.8:
		return "Good"
	elif trait_value < 1.2:
		return "Very Good"

func _round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
	
func _set_bounds(child):
	if child[1] < 0.5:
		child[1] = 0.5
	elif child[1] > 3.7:
		child[1] = 3.7
		
	if child[2] < 50:
		child[2] = 50
	elif child[2] > 110:
		child[2] = 110
	
	if child[3] < -0.8:
		child[3] = -0.8
	elif child[3] > 0.0:# 1.2:
		child[3] = 0.0 #1.2
	return child
	
func assign_id():
	id += 1
	return id
	
