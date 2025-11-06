extends RigidBody3D

func _ready():
	# Enable contact monitoring (optional if already done in editor)
	contact_monitor = true
	# Set max contacts to report (optional if already done in editor)
	max_contacts_reported = 4 
	# Connect the signal to a method in this script
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node):
	# 'body' is a reference to the other physics body that was touched.

	# You can check if the other body is a StaticBody3D
	if body is StaticBody3D:
		#var instance_name = body.owner.name ? body.owner.name : body.name
		var instance_name = body.owner.name if body.owner.name!="Node3D" else body.name
		print("Ball touched a StaticBody3D object named: ", instance_name)
		# Add your collision logic here (e.g., play sound, add points, etc.)
	else:
		print("Ball touched something else: ", body.name)
