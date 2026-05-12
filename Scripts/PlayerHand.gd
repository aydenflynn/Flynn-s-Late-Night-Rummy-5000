extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const HAND_Y_POSITION = 1100
# to make it work currently, should be 100
const CARD_WIDTH = 50

const DEFAULT_CARD_SCALE = 0.4
const CARD_BIGGER_SCALE = 0.45

var player_hand = []
var center_screen_x

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func draw_card(card):
	#player_hand.append(card)
	#print(player_hand)
	
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	
	var card_image_path = "res://Assets/cards/png/" + card + ".png"
	new_card.get_node("CardImage").texture = load(card_image_path)
	
	# All cards must be a child of CardManager
	add_child.call_deferred(new_card)
	new_card.name = card
	
	player_hand.append(new_card)
	
	update_hand_positions()

#func add_card_to_hand(card, speed):
	#if card not in player_hand:
		#player_hand.insert(0, card)
		#update_hand_positions(speed)
	#else:
		#animate_card_to_position(card, card.starting_position, DEFAULT_CARD_MOVE_SPEED)
	#
func update_hand_positions():
	var current_z_index = 0
	
	for i in range(player_hand.size()):
		var card = player_hand[i]
		
		# set the Z Index ordering
		card.z_index = current_z_index
		
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		card.position = new_position
		#animate_card_to_position(card, new_position, speed)
		
		current_z_index += 1
		
func calculate_card_position(index):
	var x_offset = (player_hand.size() - 1) * CARD_WIDTH
	var total_width = center_screen_x + index * CARD_WIDTH - x_offset / 2
	return total_width
