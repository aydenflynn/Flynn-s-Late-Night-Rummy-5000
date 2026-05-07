extends Node2D

var card_values = ["a", "2", "3", "4", "5", "6", "7", "8", "9", "10", "j", "q", "k", "a"]

var test_hand = ["5", "k", "a", "3", "q", "4"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# sort test_hand
	var value_array = []
	for card in test_hand:
		value_array.append(card_values.find(card))
	value_array.sort()
	test_hand.clear()
	
	for card in value_array:
		test_hand.append(card_values[card])
	
	print(test_hand)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
