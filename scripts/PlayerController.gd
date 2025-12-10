# PlayerController.gd
class_name PlayerController
extends CharacterBody2D

#region Variables
@export var tile_size: int = 32
@export var move_speed: float = 4.0

var target_position: Vector2
var is_moving: bool = false
var facing_direction: Vector2 = Vector2.DOWN
#endregion

#region Lifecycle
func _ready():
	target_position = global_position
#endregion

#region Input
func _physics_process(delta: float):
	if is_moving:
		_handle_movement(delta)
	else:
		_handle_input()

func _handle_input():
	var direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_accept"):
		_interact()
		return
		
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
	elif Input.is_action_pressed("ui_up"):
		direction.y = -1
	
	if direction != Vector2.ZERO:
		facing_direction = direction
		target_position = global_position + direction * tile_size
		is_moving = true
		_end_turn()
#endregion

#region Movement
func _handle_movement(delta: float):
	var distance_to_target = global_position.distance_to(target_position)
	
	if distance_to_target < 1.0:
		global_position = target_position
		is_moving = false
		return
	
	var direction = (target_position - global_position).normalized()
	global_position += direction * move_speed * tile_size * delta
#endregion

#region Interaction
func _interact():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + facing_direction * tile_size
	)
	
	var result = space_state.intersect_ray(query)
	
	if result:
		var interactable = result.collider
		if interactable.has_method("interact"):
			interactable.interact()

func _end_turn():
	get_tree().call_group("plants", "advance_turn")
#endregion
