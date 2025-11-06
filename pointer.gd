extends XRController3D

@onready var ray_cast: RayCast3D = $RayCast3D
@onready var pointer_cylinder: CSGCylinder3D = $PointerCylinder

@export var select_action_name: String = "trigger_click"

var current_hovered_object: Node = null
var previous_hovered_object: Node = null

func _ready():
	button_pressed.connect(_on_button_pressed)

func _physics_process(_delta):
	ray_cast.force_raycast_update()
	
	var distance: float
	
	if ray_cast.is_colliding():
		distance = global_transform.origin.distance_to(ray_cast.get_collision_point())
		current_hovered_object = ray_cast.get_collider()
	else:
		distance = ray_cast.target_position.length()
		current_hovered_object = null

	# Handle Hover Events
	if current_hovered_object != previous_hovered_object:
		# If previous object was valid and had the exit function, call it
		if previous_hovered_object and previous_hovered_object.has_method("on_hover_exit"):
			previous_hovered_object.on_hover_exit()
			
		# If current object is valid and has the enter function, call it
		if current_hovered_object and current_hovered_object.has_method("on_hover_enter"):
			current_hovered_object.on_hover_enter()

	previous_hovered_object = current_hovered_object
	
	# Update cylinder visual
	pointer_cylinder.height = distance
	pointer_cylinder.position.z = -distance / 2.0

func _on_button_pressed(button_name: String):
	if button_name == select_action_name:
		if current_hovered_object:
			if current_hovered_object.name == "bowl":
				get_tree().change_scene_to_file("res://bowl.tscn")
			elif current_hovered_object.name == "arch":
				get_tree().change_scene_to_file("res://arch.tscn")
