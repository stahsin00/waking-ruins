extends StaticBody2D

#region Temporary Graphics
@export var growth_colors: Array[Color] = [
	Color.DARK_GREEN,      
	Color.GREEN,           
	Color.YELLOW_GREEN     
]
@onready var visual: ColorRect = $ColorRect
#endregion

#region Variables
@export var current_stage: int = 0

@export var regrowth_delay: int = 2
var turns_since_harvest: int = 0
#endregion

#region Lifecycle
func _ready():
	add_to_group("plants")
	_update_visual()
#endregion

#region Public Methods
func interact():
	current_stage = 0
	turns_since_harvest = 0
	_update_visual()

func advance_turn():
	if current_stage == 0:
		turns_since_harvest += 1
		if turns_since_harvest >= regrowth_delay:
			current_stage = 1
			_update_visual()
	elif current_stage < growth_colors.size():
		current_stage += 1
		_update_visual()
#endregion

#region Private Methods
func _update_visual():
	if current_stage == 0:
		visual.color = Color.TRANSPARENT
	else:
		visual.color = growth_colors[current_stage - 1]
#endregion