# RoomManager.gd
extends Node

#region Variables
var current_room: int = 0
const TOTAL_ROOMS: int = 5  # rooms 0-4

var next_button: Button
var reset_button: Button
var button_created: bool = false
#endregion

#region Lifecycle
func _ready():
	call_deferred("_create_buttons")
#endregion

#region Buttons
func _create_buttons():
	# Create reset button
	reset_button = Button.new()
	reset_button.text = "RESET"
	
	# Styling for reset button
	reset_button.add_theme_color_override("font_color", Color.WHITE)
	#reset_button.add_theme_color_override("font_hover_color", Color.WHITE)
	#reset_button.add_theme_color_override("font_pressed_color", Color.WHITE)
	
	var style_reset = StyleBoxFlat.new()
	style_reset.bg_color = Color.TRANSPARENT
	style_reset.border_color = Color.WHITE
	style_reset.border_width_left = 2
	style_reset.border_width_right = 2
	style_reset.border_width_top = 2
	style_reset.border_width_bottom = 2
	style_reset.content_margin_left = 16
	style_reset.content_margin_right = 16
	style_reset.content_margin_top = 8
	style_reset.content_margin_bottom = 8
	
	reset_button.add_theme_stylebox_override("normal", style_reset)
	reset_button.add_theme_stylebox_override("hover", style_reset)
	#reset_button.add_theme_stylebox_override("pressed", style_reset)
	
	# Position in top right
	reset_button.position = Vector2(
		get_viewport().get_visible_rect().size.x - 120,
		20
	)
	
	reset_button.pressed.connect(_on_reset_button_pressed)
	
	# Create next button
	next_button = Button.new()
	next_button.text = "NEXT"
	next_button.visible = false
	
	# Styling for next button
	next_button.add_theme_color_override("font_color", Color.WHITE)
	#next_button.add_theme_color_override("font_hover_color", Color.WHITE)
	#next_button.add_theme_color_override("font_pressed_color", Color.WHITE)
	
	var style_next = StyleBoxFlat.new()
	style_next.bg_color = Color.TRANSPARENT
	style_next.border_color = Color.WHITE
	style_next.border_width_left = 2
	style_next.border_width_right = 2
	style_next.border_width_top = 2
	style_next.border_width_bottom = 2
	style_next.content_margin_left = 16
	style_next.content_margin_right = 16
	style_next.content_margin_top = 8
	style_next.content_margin_bottom = 8
	
	next_button.add_theme_stylebox_override("normal", style_next)
	next_button.add_theme_stylebox_override("hover", style_next)
	#next_button.add_theme_stylebox_override("pressed", style_next)
	
	# Position below reset button
	next_button.position = Vector2(
		get_viewport().get_visible_rect().size.x - 120,
		70  # 20 (reset top) + 40 (approx button height) + 10 (gap)
	)
	
	next_button.pressed.connect(_on_next_button_pressed)
	
	# Add to scene tree (as CanvasLayer to stay on top)
	var canvas_layer = CanvasLayer.new()
	canvas_layer.name = "RoomManagerUI"
	canvas_layer.add_child(reset_button)
	canvas_layer.add_child(next_button)
	get_tree().root.call_deferred("add_child", canvas_layer)
#endregion

#region Room Checking
func check_room_cleared():
	print("Checking room cleared...")
	print("Current room: ", current_room)
	print("Button created: ", button_created)
	
	# Don't show button if already created or no next room
	if button_created or current_room >= TOTAL_ROOMS - 1:
		print("Skipping - button exists or last room")
		return
	
	# Check all plants
	var plants = get_tree().get_nodes_in_group("plants")
	print("Plants found: ", plants.size())
	
	if plants.is_empty():
		return
	
	for plant in plants:
		print("Plant stage: ", plant.current_stage)
		if plant.current_stage != 0:
			print("Plant not cleared, returning")
			return
	
	# All plants are cleared!
	print("All plants cleared! Showing button")
	_show_next_button()

func _show_next_button():
	if next_button:
		next_button.visible = true
		button_created = true
#endregion

#region Room Transitions
func _on_reset_button_pressed():
	# Reload current room
	var room_path = "res://scenes/room" + str(current_room) + ".tscn"
	get_tree().change_scene_to_file(room_path)

func _on_next_button_pressed():
	if current_room < TOTAL_ROOMS - 1:
		current_room += 1
		_load_room(current_room)

func _load_room(room_number: int):
	var room_path = "res://scenes/room" + str(room_number) + ".tscn"
	
	# Hide next button during transition
	if next_button:
		next_button.visible = false
	
	button_created = false
	
	# Load new room
	get_tree().change_scene_to_file(room_path)
#endregion
