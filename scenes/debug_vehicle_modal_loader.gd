extends Spatial

var opened = false
var i = 1

func _ready():
	pass
	
func _process(_delta):
	if (Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_mod")):
		$VehicleModelLoader.rotation_degrees.z -= 1
		
	if (Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_mod")):
		$VehicleModelLoader.rotation_degrees.z += 1
		
	if (Input.is_action_pressed("ui_down")):
		$VehicleModelLoader.rotation_degrees.x -= 1
		
	if (Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_mod")):
		$VehicleModelLoader.rotation_degrees.y -= 1
		
	if (Input.is_action_pressed("ui_down")):
		$VehicleModelLoader.rotation_degrees.x -= 1
		
	if (Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_mod")):
		$VehicleModelLoader.rotation_degrees.y += 1
		
	if (Input.is_action_pressed("ui_up")):
		$VehicleModelLoader.rotation_degrees.x += 1
		
#	get_node("VehicleModelLoader/PartController").rotate_part("DoorFrontLeft", i)
#	get_node("VehicleModelLoader/PartController").rotate_part("DoorFrontRight", i)
#	get_node("VehicleModelLoader/PartController").rotate_part("Hood", i)
	
	i += 1
	
	if i > 360:
		i = 0
		
	if (Input.is_action_just_pressed("ui_cancel")):
		if not opened:
			opened = true
			get_node("VehicleModelLoader/PartController").rotate_part("DoorFrontLeft", 30)
			get_node("VehicleModelLoader/PartController").rotate_part("DoorFrontRight", 30)
			get_node("VehicleModelLoader/PartController").rotate_part("Hood", 30)
		else:
			opened = false
			get_node("VehicleModelLoader/PartController").rotate_part("DoorFrontLeft", 0)
			get_node("VehicleModelLoader/PartController").rotate_part("DoorFrontRight", 0)
			get_node("VehicleModelLoader/PartController").rotate_part("Hood", 0)
			
		
	if (Input.is_action_just_pressed("ui_accept")):
		get_node("VehicleModelLoader/PartDetacher").detatch_part("BumperFront")
		get_node("VehicleModelLoader/PartDetacher").detatch_part("Hood")
		get_node("VehicleModelLoader/PartDetacher").detatch_part("BumperBack")
		get_node("VehicleModelLoader/PartDetacher").detatch_part("DoorFrontRight")
		get_node("VehicleModelLoader/PartDetacher").detatch_part("DoorFrontLeft")
		get_node("VehicleModelLoader/PartDetacher").detatch_part("HeadlightRight")
		get_node("VehicleModelLoader/PartDetacher").detatch_part("HeadlightLeft")
#		get_node("VehicleModelLoader/PartDetacher").detatch_part("Chassis")
	pass
