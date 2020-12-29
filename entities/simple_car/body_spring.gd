extends Spatial

onready var rb: RigidBody = get_parent()
onready var spring_pitch = $SpringPitch
onready var spring_roll = $SpringRoll

var v0: Vector3
var acceleration: Vector3 = Vector3.ZERO

func _apply_spring_motion_to_self():
	self.rotation_degrees.x = spring_pitch.value
	self.rotation_degrees.z = spring_roll.value

func _physics_process(delta):
	if v0:
		acceleration = (rb.linear_velocity - v0) / delta
		
	v0 = rb.linear_velocity
	
	var pitch_acceleration = acceleration.dot(-self.global_transform.basis.z)
	var roll_acceleration = acceleration.dot(self.global_transform.basis.x)
	
	spring_pitch.add_velocity(pitch_acceleration)
	spring_roll.add_velocity(roll_acceleration)
	
	_apply_spring_motion_to_self()
	
	DebugDraw.draw_line_3d(
		self.global_transform.origin,
		self.global_transform.origin + (-acceleration / 2),
		Color.purple
	)
	
	pass


func _on_DynamicBody_door_opened(name: String):
	if name == "DoorFrontRight":
		spring_roll.add_velocity(-20)
		
	if name == "DoorFrontLeft":
		spring_roll.add_velocity(20)


func _on_DynamicBody_hood_opened():
	spring_pitch.add_velocity(10)

func _on_DynamicBody_door_closed(name: String):
	if name == "DoorFrontRight":
		spring_roll.add_velocity(20)
		
	if name == "DoorFrontLeft":
		spring_roll.add_velocity(-20)
