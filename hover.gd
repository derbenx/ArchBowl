extends StaticBody3D
var base_scale: Vector3
var hover_scale: Vector3

func _ready():
	base_scale = scale
	hover_scale = base_scale * 1.5

# Function to call when the controller points at this object
func on_hover_enter():
	scale = hover_scale

# Function to call when the controller looks away
func on_hover_exit():
	scale = base_scale
