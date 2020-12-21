extends RigidBody

onready var turnPosition: Position3D = $TurnPosition

func _ready():
#	Engine.time_scale = 0.1
	pass
	

func _process(delta):
#	var forward = get_global_transform().basis.z.normalized()
#	self.add_force(Vector3.RIGHT * 5, self.to_local(turnPosition.global_transform.origin))

	if Input.is_action_pressed("ui_up"):
		self.add_central_force(-self.global_transform.basis.z.normalized() * 200)
	
	if Input.is_action_pressed("ui_left"):
		self.add_force(-self.global_transform.basis.x.normalized() * 200, (self.global_transform.origin + Vector3(1, 0, -1)) - self.global_transform.origin)
		
	if Input.is_action_pressed("ui_right"):
		self.add_force(self.global_transform.basis.x.normalized() * 200, (self.global_transform.origin + Vector3(-1, 0, -1)) - self.global_transform.origin)
	
	pass
