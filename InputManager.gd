extends Node2D

signal card_clicked

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 2
const COLLISION_MASK_DISCARD_BUTTON = 3
const COLLISION_MASK_MELD_BUTTON = 4

var is_dragging = false
var have_card_dragging = false
var drag_threshold = 10
var press_pos = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			press_pos = event.position
			is_dragging = false
		
		# normal mouse click	
		elif !is_dragging:
			raycast_at_cursor()
			
		# normal mouse click release
		else:
			print("stop dragging")
			is_dragging = false
			$"../CardManager".stop_drag()
			have_card_dragging = false
	
	# click and dragging mouse
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if event.position.distance_to(press_pos) > drag_threshold:
			is_dragging = true
			raycast_at_cursor()
			
func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		# gets the node of the card
		var card_found = result[0].collider.get_parent()
		
		if result_collision_mask == COLLISION_MASK_CARD and is_dragging and !have_card_dragging:
			$"../CardManager".start_drag(card_found)
			have_card_dragging = true
			
		elif result_collision_mask == COLLISION_MASK_CARD and !card_found.is_selected and !card_found.is_melded and !is_dragging:
			
			# if card is in discard pile
			if card_found.is_discarded:
				$"../CardManager".handle_discard_pickup(card_found)
			# if card is in players hand
			else:
				$"../CardManager".handle_select_card(card_found)
				emit_signal("card_clicked")
					
		elif result_collision_mask == COLLISION_MASK_CARD and card_found.is_selected:
			$"../CardManager".handle_deselect_card(card_found)
			
		elif result_collision_mask  == COLLISION_MASK_DECK:
			$"../CardManager".draw_card()

func meld_button_pressed() -> void:
	$"../CardManager".handle_player_melds()

func discard_button_pressed() -> void:
	$"../CardManager".handle_player_discards()
