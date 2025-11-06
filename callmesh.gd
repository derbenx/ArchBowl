extends XRController3D

@export var grip_action_name: String = "grip_click"
@export var trig_action_name: String = "trigger_click"
@onready var bow_object: Node3D = get_node("/root/Node3D/bow2") # Path to the bow object
@onready var arr_object: Node3D = get_node("/root/Node3D/RigidBody3D") # Path to the bow object

var original_parent: Node = null

func _ready():
	original_parent = bow_object.get_parent()
	button_pressed.connect(_on_button_pressed)
	button_released.connect(_on_button_released)

func _on_button_pressed(button: String):
	print(button)
	if button == "by_button":
		get_tree().change_scene_to_file("res://start.tscn")
	if button == grip_action_name:
		grab_bow()
	if button == trig_action_name:
		grab_arrow()

func _on_button_released(button: String):
	if button == grip_action_name:
		drop_bow()
	if button == trig_action_name:
		drop_arrow()

func grab_bow():
	
	if not bow_object or bow_object.get_parent() == self: return
	
	var global_pos = bow_object.global_transform
	bow_object.get_parent().remove_child(bow_object)
	add_child(bow_object)
	bow_object.global_transform = global_pos 
	
	# Call the new function on the bow script
	if bow_object.has_method("on_grab"):
		bow_object.on_grab(self)

func drop_bow():
	if not bow_object or bow_object.get_parent() != self: return

	var global_pos = bow_object.global_transform
	remove_child(bow_object)
	original_parent.add_child(bow_object)
	bow_object.global_transform = global_pos
	
	# Call the new function on the bow script
	if bow_object.has_method("on_drop"):
		bow_object.on_drop()

func grab_arrow():
	if not arr_object or arr_object.get_parent() == self: return
	
	var global_pos = arr_object.global_transform
	arr_object.get_parent().remove_child(arr_object)
	add_child(arr_object)
	arr_object.global_transform = global_pos 
	
	# Call the new function on the bow script
	if arr_object.has_method("on_grab"):
		arr_object.on_grab(self)

func drop_arrow():
	if not arr_object or arr_object.get_parent() != self: return

	var global_pos = arr_object.global_transform
	remove_child(arr_object)
	original_parent.add_child(arr_object)
	arr_object.global_transform = global_pos
	
	# Call the new function on the bow script
	if arr_object.has_method("on_drop"):
		arr_object.on_drop()
