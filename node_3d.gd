extends Node3D
var xr_interface: XRInterface
func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("XR Init")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
		Engine.physics_ticks_per_second = 90
	else:
		print("XR Not Init")
	
