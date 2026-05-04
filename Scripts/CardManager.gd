extends Node2D

const STARTING_NUMBER_OF_CARDS = 7
const DISCARD_POSITON = Vector2(420, 660)

var game_deck = ["c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "cj", 
	"cq", "ck", "ca", "h2", "h3", "h4", "h5", "h6", "h7", "h8", "h9", "h10", 
	"hj", "hq", "hk", "ha", "d2", "d3", "d4", "d5", "d6", "d7", "d8", "d9", 
	"d10", "dj", "dq", "dk", "da", "s2", "s3", "s4", "s5", "s6", "s7", "s8", 
	"s9", "s10", "sj", "sq", "sk", "sa"]
	
var selected_cards = []
	
var card_being_dragged
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var screen_size = get_viewport_rect().size
	
	# shuffle the deck
	game_deck.shuffle()
	
	# draw cards
	for i in range(STARTING_NUMBER_OF_CARDS):
		$"../PlayerHand".draw_card(game_deck.pop_front())
		
	$"../Deck/RichTextLabel".text = str(game_deck.size())
	
	# display the players total score
	$"../Player/RichTextLabel".text = "Score: " + str($"../Player".total_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if card_being_dragged:
		#var mouse_pos = get_global_mouse_position()
		##card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), clamp(mouse_pos.y, 0, screen_size.y))
		#card_being_dragged.position = Vector2(mouse_pos.x, mouse_pos.y)
	pass

func draw_card():
	$"../PlayerHand".draw_card(game_deck.pop_front())
	$"../Deck/RichTextLabel".text = str(game_deck.size())
		
func handle_select_card(card):
	card.is_selected = true
	card.position.y -= 50
	
	selected_cards.append(card)
	$"../PlayerHand".player_hand.erase(card)
	
func handle_deselect_card(card):
	card.is_selected = false
	card.position.y += 50
	
	$"../PlayerHand".player_hand.append(card)
	selected_cards.erase(card)
	
func handle_player_discards():
	if selected_cards.size() == 1:
		for card in selected_cards:
			
			$"../Discard".discard_deck.append(card)
			selected_cards.erase(card)
		
			card.is_discarded = true 
			card.is_selected = false
		
		$"../PlayerHand".update_hand_positions()
		$"../Discard".update_dicard_card_positions()
		
		handle_round_over()
	else:
		print("Need 1 card selected to discard")
	
func handle_player_melds():
	#TODO need to handle meld checking and for layoff of single card
	#if selected_cards.size() >= 3:
	for card in selected_cards:
		card.is_selected = false
		card.is_melded = true
		
	var temp_cards = selected_cards.duplicate()
	
	$"../PlayerMelds".player_melds.append(temp_cards)
	selected_cards.clear()
	
	$"../PlayerMelds".update_meld_positions()
	
	$"../PlayerHand".update_hand_positions()
	
	handle_round_over()
		
	#else:
		#print("Need minimum 3 cards to meld")
	
func handle_discard_pickup(card):
	# handle multiple card pickup
	var starting_discard_deck_size = $"../Discard".discard_deck.size()
	var temp_discard_deck = []
	
	var card_index = $"../Discard".discard_deck.find(card)
	# check if cards to the right of clicked card
	if card_index != ($"../Discard".discard_deck.size() - 1):
		# create temp deck to add to player hand
		temp_discard_deck = $"../Discard".discard_deck.slice(card_index, $"../Discard".discard_deck.size())
		
		# update picked up cards to be not discarded
		for i in temp_discard_deck:
			i.is_discarded = false
		
		$"../PlayerHand".player_hand = $"../PlayerHand".player_hand + temp_discard_deck
		
		# remove cards from discard
		$"../Discard".discard_deck.resize(starting_discard_deck_size - temp_discard_deck.size())
		#print($"../Discard".discard_deck)
			
	#handle single card pickup
	else: 
		$"../PlayerHand".player_hand.append(card)
		$"../Discard".discard_deck.erase(card)
		
		# card back in hand, no longer discarded
		card.is_discarded = false
	
	$"../PlayerHand".update_hand_positions()
	$"../Discard".update_dicard_card_positions()
	
func handle_round_over():
	if $"../PlayerHand".player_hand.is_empty():
		print("ROUND OVER")
		for meld in range($"../PlayerMelds".player_melds.size()):
			for card in $"../PlayerMelds".player_melds[meld]:
				var temp_value = card.name
				var value = temp_value.substr(1, temp_value.length())
				
				if value == "j" or value == "q" or value == "k" or value == "10":
					$"../Player".total_score += 10
				elif value == "a":
					$"../Player".total_score += 15
				else:
					$"../Player".total_score += 5
				
		$"../Player/RichTextLabel".text = "Score: " + str($"../Player".total_score)
		
#func handle_player_hand_sorting(card):
	#card_being_dragged = card
	
	
