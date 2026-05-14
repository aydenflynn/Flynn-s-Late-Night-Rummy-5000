extends Node2D

var is_round_over




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_round_over = false
	
	var screen_size = get_viewport().size
	print(screen_size)
	
	# layout setup here
	$MeldButton.position.x = (screen_size.x / 2) - (screen_size.x / 8)
	$MeldButton.position.y = (screen_size.y / 2) + (screen_size.y / 5)
	
	$DiscardButton.position.x = (screen_size.x / 2) + (screen_size.x / 8)
	$DiscardButton.position.y = (screen_size.y / 2) + (screen_size.y / 5)
	
	$Deck.position.x = (screen_size.x / 2) - (screen_size.x / 10)
	$Deck.position.y = (screen_size.y / 2) + (screen_size.y / 40)
	
	$Discard.position.x = (screen_size.x / 2) + (screen_size.x / 10)
	$Discard.position.y = (screen_size.y / 2) + (screen_size.y / 40)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func placeholder_or_future_handle_roundover():
	if is_round_over:
		#TODO do the things to reset for the next round
		#TODO add up scores
		#TODO FOR MUCH LATER: go to shop
		#TODO set new playing field
		
		# reset checker for the next round
		is_round_over = false
