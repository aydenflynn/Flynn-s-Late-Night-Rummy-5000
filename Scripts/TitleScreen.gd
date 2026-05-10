extends AnimationPlayer

var play_title_screen = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if play_title_screen:
		play("TitleScreen")
	else: 
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
		
func _on_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
