extends Node2D



var discard_deck = []

var card_width = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../InputManager".card_clicked.connect(handle_click)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func handle_click():
	pass

func update_dicard_card_positions():
	var current_z_index = 0
	
	var screen_size = get_viewport().size
	var discard_y_position = (screen_size.y / 2) + (screen_size.y / 40)
	print(discard_y_position)
	
	if discard_deck.size() > 0:
		for i in range(discard_deck.size()):
			var card = discard_deck[i]
			
			# set the Z Index ordering
			card.z_index = current_z_index
			
			var new_position = Vector2(calculate_card_position(i), discard_y_position)
			card.position = new_position
			
			current_z_index += 1
		
func calculate_card_position(index):
	if discard_deck.size() > 7:
		card_width = 350 / discard_deck.size()
	
	var center_screen_x = self.position.x + 12
	var total_width = center_screen_x + index * card_width 
	return total_width
