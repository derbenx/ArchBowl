extends RigidBody3D

func _ready():
	# Enable contact monitoring for the arrow
	self.contact_monitor = true
	self.max_contacts_reported = 4
	body_entered.connect(_on_arrow_body_entered)
	
	# Ensure your RayCast3D node is enabled
	#ray_cast.enabled = true

func _on_arrow_body_entered(body: Node):
	# body.name body.owner.name
	print("Arrow hit something: ", body.get_parent().name)
	self.freeze = true
	
