extends XROrigin3D

# IMPORTANT: Update this path to point to your WorldEnvironment node!
#@onready var world_environment: WorldEnvironment = $"XROrigin3D/WorldEnvironment"
@onready var world_environment: WorldEnvironment = $"WorldEnvironment"

func _ready():
	var openxr_interface = XRServer.find_interface("OpenXR")
	if openxr_interface:
		openxr_interface.session_begun.connect(_enable_passthrough)
	else:
		print("Error: OpenXR interface not found.")

func _enable_passthrough():
	var openxr_interface = XRServer.find_interface("OpenXR")
	if not openxr_interface:
		return

	# Check if the device supports the blend mode required for passthrough
	if XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND in openxr_interface.get_supported_environment_blend_modes():
		# Make the viewport background transparent
		get_viewport().transparent_bg = true

		# Set the environment background to a fully transparent color
		if world_environment and world_environment.environment:
			world_environment.environment.background_mode = Environment.BG_COLOR
			world_environment.environment.background_color = Color(0, 0, 0, 0)
		
		# Set the blend mode to alpha blend to show the camera feed
		openxr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND
		print("Passthrough enabled.")
	else:
		print("Passthrough not supported by this device.")
