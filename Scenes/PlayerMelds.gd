extends Node2D

const MELD_AREA_Y = 800
const CARD_WIDTH = 50

var player_melds = []
var center_screen_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_meld_positions():
	var card_count = 0
	
	for meld_number in range(player_melds.size()):
		for index in range(player_melds[meld_number].size()):
			var new_position = Vector2(calculate_card_position(card_count), MELD_AREA_Y)
			var card = player_melds[meld_number][index]
			card.position = new_position
			card.scale = Vector2(0.2, 0.2)
			
			card_count += 1
			
func calculate_card_position(card_count):
	var total_cards_in_melds = 0
	
	for meld_number in range(player_melds.size()):
		for index in range(player_melds[meld_number].size()):
			total_cards_in_melds += 1
	
	var x_offset = (total_cards_in_melds - 1) * CARD_WIDTH
	var total_width = center_screen_x + card_count * CARD_WIDTH - x_offset / 2
	return total_width
