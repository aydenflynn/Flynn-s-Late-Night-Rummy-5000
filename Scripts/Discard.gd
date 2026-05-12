extends Node2D

const DISCARD_Y_POSITION = 660
const CARD_WIDTH = 100

var discard_deck = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../InputManager".card_clicked.connect(handle_click)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func handle_click():
	pass

func update_dicard_card_positions():
	if discard_deck.size() > 0:
		for i in range(discard_deck.size()):
			var new_position = Vector2(calculate_card_position(i), DISCARD_Y_POSITION)
			var card = discard_deck[i]
			card.position = new_position
			#animate_card_to_position(card, new_position, speed)
		
func calculate_card_position(index):
	var center_screen_x = 420
	#var x_offset = (discard_deck.size() - 1) * CARD_WIDTH
	var total_width = center_screen_x + index * CARD_WIDTH 
	#var total_width = center_screen_x + index * CARD_WIDTH - x_offset / 2
	return total_width
