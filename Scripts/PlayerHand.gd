extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const HAND_Y_POSITION = 1100

const DEFAULT_CARD_SCALE = 0.4
const CARD_BIGGER_SCALE = 0.45

var player_hand = []
var center_screen_x

var card_width = 50

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func draw_card(card):
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	
	var card_image_path = "res://Assets/cards/png/" + card + ".png"
	new_card.get_node("CardImage").texture = load(card_image_path)
	
	# All cards must be a child of CardManager
	add_child.call_deferred(new_card)
	new_card.name = card
	
	player_hand.append(new_card)
	
	update_hand_positions()

func update_hand_positions():
	var current_z_index = 0
	
	for i in range(player_hand.size()):
		var card = player_hand[i]
		
		# set the Z Index ordering
		card.z_index = current_z_index
		
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		card.position = new_position
		
		current_z_index += 1
		
func calculate_card_position(index):
	if player_hand.size() > 7:
		card_width = 350 / player_hand.size()
	var x_offset = (player_hand.size() - 1) * card_width
	var total_width = center_screen_x + index * card_width - x_offset / 2
	return total_width
