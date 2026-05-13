extends Node2D

const STARTING_NUMBER_OF_CARDS = 7
const DISCARD_POSITON = Vector2(420, 660)
const CARD_SCENE_PATH = "res://Scenes/Card.tscn"

var card_values_high_ace = ["placeholder", "2", "3", "4", "5", "6", "7", "8", "9", "10", "j", "q", "k", "a"]
var card_values_low_ace = ["placeholder", "a", "2", "3", "4", "5", "6", "7", "8", "9", "10", "j", "q", "k"]

var game_deck = ["c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "cj", 
	"cq", "ck", "ca", "h2", "h3", "h4", "h5", "h6", "h7", "h8", "h9", "h10", 
	"hj", "hq", "hk", "ha", "d2", "d3", "d4", "d5", "d6", "d7", "d8", "d9", 
	"d10", "dj", "dq", "dk", "da", "s2", "s3", "s4", "s5", "s6", "s7", "s8", 
	"s9", "s10", "sj", "sq", "sk", "sa"]
	
var TEST_DECK = []
	
var selected_cards = []
	
var card_being_dragged
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	round_setup()
	
	# display the players total score
	$"../Player/RichTextLabel".text = "Score: " + str($"../Player".total_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# move card being dragged with cursor
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(mouse_pos.x, clamp(mouse_pos.y, 1100, 1100))
		
		start_drag(card_being_dragged)
	
func round_setup():
	# shuffle the deck
	game_deck.shuffle()
	
	# draw cards and allow for a test deck to be used if the TEST_DECK array has cards set in it
	if TEST_DECK:
		for card in TEST_DECK.size():
			$"../PlayerHand".draw_card(TEST_DECK.pop_front())
	else:
		for i in range(STARTING_NUMBER_OF_CARDS):
			$"../PlayerHand".draw_card(game_deck.pop_front())
		
	# flip the first card to start the game
	var first_card = game_deck.pop_front()
	
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	
	var card_image_path = "res://Assets/cards/png/" + first_card + ".png"
	new_card.get_node("CardImage").texture = load(card_image_path)
	
	# All cards must be a child of CardManager
	add_child.call_deferred(new_card)
	new_card.name = first_card
	new_card.is_discarded = true
	
	$"../Discard".discard_deck.append(new_card)
	$"../Discard".update_dicard_card_positions()
	
	$"../Deck/RichTextLabel".text = str(game_deck.size())

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

func set_checker():
	var temp_value = selected_cards[0].name
	var first_card_value = temp_value.substr(1, temp_value.length())
	
	for index in range(selected_cards.size()):
		var current_card_temp_value = selected_cards[index].name
		var current_card_value = current_card_temp_value.substr(1, current_card_temp_value.length())
		if current_card_value != first_card_value:
			print("Not a set")
			return false
			
	return true	

func run_checker():
	var suits = []
	var temp_values = []
	var values = []
	
	for card in selected_cards:
		var temp = ""
		temp = card.name.substr(0,1)
		suits.append(temp)
		
		temp = card.name.substr(1, card.name.length())
		temp_values.append(temp)
	
	# check all the same suit
	if !(suits.all(func(element): return element == suits[0])): 
		print("Not a run")
		return false
		
	# check if valid run values
	for item in temp_values:
		if temp_values.find("k") != -1:
		# if there is a king: card_values_high_ace
		# else: card_values_low_ace
			values.append(card_values_high_ace.find(item))
		else:
			values.append(card_values_low_ace.find(item))
	values.sort()
	
	# I THINK THIS COULD BE A RECURSIVE FUNCTION
	for index in range(values.size()):
		# if not the last index
		if index != values.size() - 1:
			if (values[index + 1]) - values[index] != 1:
				print("Not a run")
				return false
	
	# passed the checks, it is a run
	return true
	
func layoff_set_checker():
	var card = selected_cards[0].name
		
	# check if there is a set to layoff in
	for meld_number in range($"../PlayerMelds".player_melds.size()):
		# if the first card in the meld matches, we know it is good
		var value_to_check = $"../PlayerMelds".player_melds[meld_number][0].name.substr(1,  
			$"../PlayerMelds".player_melds[meld_number][0].name.length())
	
		if !(value_to_check == card.substr(1, card.length())):
			print("Can't layoff")
			return false
	
	return true
			
func layoff_run_checker():
	var card = selected_cards[0].name
	
	# check if there is a run to layoff in
	for meld_number in range($"../PlayerMelds".player_melds.size()):
		var value_to_check = $"../PlayerMelds".player_melds[meld_number][0].name.substr(0,1)
		
		# check if the first card's suit in the meld matches
		if !(card.substr(0,1) == value_to_check):
			return false
		
		for index in range($"../PlayerMelds".player_melds[meld_number].size()):
			value_to_check = $"../PlayerMelds".player_melds[meld_number][index].name.substr(1,  
				$"../PlayerMelds".player_melds[meld_number][index].name.length())
			
			if !(int(card.substr(1, card.length())) - int(value_to_check) == 1):
				return false

	return true
			
	#for meld_number in range($"../PlayerMelds".player_melds.size()):
		#for index in $"../PlayerMelds".player_melds[meld_number]:
			# check if new card is the same as the suits in the meld
			# could be good to somehow attach the suit information in player_melds for the meld
			# when we are already checking the meld
			#if suits.all(func(element): return element == suits[0]): 
	

func handle_player_melds():	
	if selected_cards.size() >= 3:
		# handle set of cards
		if set_checker():
			print("Is a set")
		
		# handle run of cards
		elif run_checker():
			print("Is a run")
			
		else:
			# reset selected cards?
			#var temp_cards = selected_cards.duplicate()
			#$"../PlayerMelds".player_melds.append(temp_cards)
			#selected_cards.clear()
			#
			#$"../PlayerHand".update_hand_positions()
			print("Not a legal meld")
			return
			
	# handle layoff 
	elif selected_cards.size() == 1:
		if layoff_set_checker():
			pass
		
		elif layoff_run_checker():
			pass
		
		else:
			return 
	
	$"../Cashout".play()
	
	# ALL THE BELOW CODE NEEDS TO PUT IN WHERE A PROPER SET IS FOUND
	for card in selected_cards:
		card.is_selected = false
		card.is_melded = true
		
	var temp_cards = selected_cards.duplicate()
	
	$"../PlayerMelds".player_melds.append(temp_cards)
	selected_cards.clear()
	
	$"../PlayerMelds".update_meld_positions()
	
	$"../PlayerHand".update_hand_positions()
	
	handle_round_over()
	
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

func card_sort_swap(other_card_index, card_being_dragged_index):
	$"../Click".play()
	var temp = $"../PlayerHand".player_hand[other_card_index]
	$"../PlayerHand".player_hand[other_card_index] = $"../PlayerHand".player_hand[card_being_dragged_index]
	$"../PlayerHand".player_hand[card_being_dragged_index] = temp
	$"../PlayerHand".update_hand_positions()

func start_drag(card):
	card_being_dragged = card
	var card_being_dragged_index = $"../PlayerHand".player_hand.find(card_being_dragged)
	
	# SWAP RIGHT
	# check if not last card
	if !(card_being_dragged_index == $"../PlayerHand".player_hand.size() - 1):
		if card_being_dragged.position.x > $"../PlayerHand".player_hand[card_being_dragged_index + 1].position.x:
			card_sort_swap(card_being_dragged_index + 1, card_being_dragged_index)

	# SWAP LEFT
	# check if not first card
	if !(card_being_dragged_index == 0):
		if card_being_dragged.position.x < $"../PlayerHand".player_hand[card_being_dragged_index - 1].position.x:
			card_sort_swap(card_being_dragged_index - 1, card_being_dragged_index)
	
func stop_drag():
	card_being_dragged = null
	$"../PlayerHand".update_hand_positions()
	
