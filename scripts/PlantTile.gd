extends StaticBody2D

#region Temporary Graphics
@export var growth_colors: Array[Color] = [
	Color.DARK_GREEN,      # Stage 1
	Color.GREEN,           # Stage 2
	Color.YELLOW_GREEN     # Stage 3
]
@onready var visual: ColorRect = $ColorRect
#endregion

#region Variables
var current_stage: int = 0
#endregion

#region Lifecycle
func _ready():
	add_to_group("plants")
	_update_visual()
#endregion

#region Public Methods
func interact():
	current_stage = 0
	_update_visual()

func advance_turn():
	if current_stage < growth_colors.size():
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