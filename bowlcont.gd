extends XRController3D

@export var grab_button_name: String = "trigger_click"

@onready var ball: RigidBody3D = get_node("/root/Node3D/ball") # Adjust the path to your ball node
var held_object: RigidBody3D = null
var grab_joint: Generic6DOFJoint3D = null

# For calculating release velocity
var previous_global_transform: Transform3D
var previous_linear_velocity: Vector3
var previous_angular_velocity: Vector3

func _ready():
	button_pressed.connect(_on_button_pressed)
	button_released.connect(_on_button_released)
	
	previous_global_transform = global_transform
	previous_linear_velocity = Vector3.ZERO
	previous_angular_velocity = Vector3.ZERO

func _physics_process(delta):
	var current_quat = global_transform.basis.get_rotation_quaternion()
	var previous_quat = previous_global_transform.basis.get_rotation_quaternion()
	var delta_quat = previous_quat.inverse() * current_quat
	
	previous_linear_velocity = (global_transform.origin - previous_global_transform.origin) / delta
	previous_angular_velocity = delta_quat.get_axis() * delta_quat.get_angle() / delta
	
	previous_global_transform = global_transform

func _on_button_pressed(button: String):
	if button == "by_button":
		get_tree().change_scene_to_file("res://start.tscn")
	if button == grab_button_name:
		try_grab_object()

func _on_button_released(button: String):
	if button == grab_button_name:
		drop_object()

func try_grab_object():
	if not ball or held_object: return

	held_object = ball

	held_object.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	held_object.freeze = true

	grab_joint = Generic6DOFJoint3D.new()
	grab_joint.node_a = get_path() 
	grab_joint.node_b = held_object.get_path() 
	
	# Correct method for Godot 4.5.1: Use axis-specific flags and set parameters with values directly
	
	# Lock all linear movement (X, Y, Z axes)
	grab_joint.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, true)
	grab_joint.set_linear_limit_x_lower(0.0)
	grab_joint.set_linear_limit_x_upper(0.0)
	
	grab_joint.set_flag_y(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, true)
	grab_joint.set_linear_limit_y_lower(0.0)
	grab_joint.set_linear_limit_y_upper(0.0)
	
	grab_joint.set_flag_z(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, true)
	grab_joint.set_linear_limit_z_lower(0.0)
	grab_joint.set_linear_limit_z_upper(0.0)
	
	# Lock all angular movement (X, Y, Z axes)
	grab_joint.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT, true)
	grab_joint.set_angular_limit_x_lower(0.0)
	grab_joint.set_angular_limit_x_upper(0.0)

	grab_joint.set_flag_y(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT, true)
	grab_joint.set_angular_limit_y_lower(0.0)
	grab_joint.set_angular_limit_y_upper(0.0)

	grab_joint.set_flag_z(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT, true)
	grab_joint.set_angular_limit_z_lower(0.0)
	grab_joint.set_angular_limit_z_upper(0.0)


	# Place the joint at the ball's location to start
	grab_joint.global_transform = held_object.global_transform

	add_child(grab_joint)


func drop_object():
	if not held_object: return

	# Remove the joint
	if grab_joint and is_instance_valid(grab_joint):
		remove_child(grab_joint)
		grab_joint.queue_free()
		grab_joint = null

	# Unfreeze the ball's physics
	held_object.freeze = false
	# Setting freeze = false reverts it to the default Rigid mode.
	
	# Apply the stored velocity and angular velocity to the ball
	held_object.linear_velocity = previous_linear_velocity * 2.0 # Multiplier to make throwing feel better
	held_object.angular_velocity = previous_angular_velocity * 2.0

	held_object = null
