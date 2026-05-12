extends Node2D

var is_round_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_round_over = false

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
