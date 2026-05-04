extends Node2D

signal card_clicked

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 2
#const COLLISION_MASK_DISCARD = 4

var is_dragging = false
var drag_threshold = 10
var press_pos = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			press_pos = event.position
			is_dragging = false
		
		# normal mouse click	
		elif not is_dragging:
			raycast_at_cursor()
			
		# normal mouse click release
		else:
			is_dragging = false
	
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
		if result_collision_mask == COLLISION_MASK_CARD:
			# gets the node of the card
			var card_found = result[0].collider.get_parent()
			
			if is_dragging:
				#$"../CardManager".handle_player_hand_sorting(card_found)
				pass
			else:
				# if card is in discard pile
				if card_found.is_discarded:
					$"../CardManager".handle_discard_pickup(card_found)
				# if card is in players hand
				else:
					$"../CardManager".handle_discard(card_found)
					
					emit_signal("card_clicked")

		elif result_collision_mask  == COLLISION_MASK_DECK:
			$"../CardManager".draw_card()
