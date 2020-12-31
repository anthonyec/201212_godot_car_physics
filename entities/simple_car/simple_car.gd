extends RigidBody

export var disable_controls: bool
export var show_debug: bool = false
export var turn_curve: Curve

var max_acceleration: float = 20
var max_turn_torque: float = 20

var wheel_turn = 0
var acceleration = 0;
var handebrake = 0

func _ready():
	self.axis_lock_angular_x = true
	self.axis_lock_angular_y = false
	self.axis_lock_angular_z = true

	pass
	
func _process_controls():
	# TODO: Move these into seperate node that can be controlled with signals or something
	var horizontal_axis = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	var vertical_axis = Input.get_action_strength("accelerate") - Input.get_action_strength("brake")
	var handebrake_axis = Input.get_action_strength("handbrake")
	
	wheel_turn = horizontal_axis
	acceleration = vertical_axis
	handebrake = handebrake_axis
	
func _apply_control_forces():
	if !disable_controls:
		_process_controls()
	
	# TODO: Maybe there is a better way that does not rely on curves by turning angles?
	var forwards_velocity = self.linear_velocity.dot(-self.global_transform.basis.z.normalized())
	var speed_percent_abs = abs(forwards_velocity / max_acceleration)
	var interpolated_percent = turn_curve.interpolate(speed_percent_abs)

	var turn_torque = (wheel_turn * max_turn_torque) * interpolated_percent;
	var acceleration_force = acceleration * max_acceleration;
	
	DebugDraw.set_text("speed_percent_abs", speed_percent_abs)
	DebugDraw.set_text("turn_torque", turn_torque)
	
	self.add_central_force(
		-self.global_transform.basis.z.normalized() * (acceleration_force)
	)
	
	# TODO: Work out how to slow the car when handbrake is applied
#	if handebrake != 0:
#		self.add_central_force(self.global_transform.basis.z.normalized() * 18)

	self.add_torque(Vector3(0, turn_torque, 0))

func _apply_counter_forces():
	var handebrake_percent = 1 - (0.5 * handebrake)

	# Add friction forward and backward
	var forwards_velocity = self.linear_velocity.dot(-self.global_transform.basis.z.normalized())
	var speed_percent = forwards_velocity / max_acceleration
	
	## Counter torque to add more friction and make turning responsive
	## TODO: Turn responsivness into var
	var counter_torque = (max_turn_torque / 2);
	self.add_torque(Vector3(0, -self.angular_velocity.y * counter_torque * handebrake_percent, 0))
	
	# Forward friction
	self.add_central_force(
		self.global_transform.basis.z.normalized() * (forwards_velocity * 1)
	)
	
	# Add counter sideways force to reduce oversteer
	# https://www.reddit.com/r/Unity3D/comments/8ms5r5/how_to_find_local_sideways_velocity_of_an_object/
	var sideways_velocity = self.linear_velocity.dot(self.global_transform.basis.x.normalized())
		
	# TODO: Make magic number 5 into a var, maybe max sideways friction? 
	var counter_sideways_force = -self.global_transform.basis.x.normalized() * (sideways_velocity * (5 * handebrake_percent))
	
	self.add_central_force(counter_sideways_force)
	
	var skid = clamp(abs((sideways_velocity / (max_acceleration - forwards_velocity))), 0, 1)
	
	if show_debug:
		DebugDraw.set_text("forwards_velocity", forwards_velocity)
		DebugDraw.set_text("sideways_velocity", sideways_velocity)
		DebugDraw.set_text("skid", skid)
		DebugDraw.set_text("handebrake_percent", handebrake_percent)
			
		DebugDraw.draw_ray_3d(
			self.global_transform.origin, #  + (-self.global_transform.basis.z.normalized() * 0.2)
			self.global_transform.basis.x.normalized(),
			sideways_velocity,
			Color.blue
		)

		DebugDraw.draw_line_3d(
			self.global_transform.origin,
			self.global_transform.origin + self.linear_velocity,
			Color.red
		)

func _physics_process(delta):
	_apply_control_forces()
	_apply_counter_forces()
