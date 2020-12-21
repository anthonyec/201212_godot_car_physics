extends RigidBody

export var force = 1
export var turn_force = 0.1

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var pos = $PushPosition.global_transform.origin
	
	DebugDraw.draw_ray_3d(
		$PushPosition.global_transform.origin,
		-self.global_transform.basis.z.normalized(),
		10,
		Color.blue
	)
	
	DebugDraw.draw_ray_3d(
		$LeftPosition.global_transform.origin,
		self.global_transform.basis.x.normalized(),
		10,
		Color.red
	)

	# https://www.reddit.com/r/godot/comments/bvf7an/really_confused_on_how_add_force_works/
	self.add_force(
		-self.global_transform.basis.z.normalized() * force,
		$PushPosition.global_transform.origin - self.global_transform.origin
	)
	
	self.add_force(
		self.global_transform.basis.x.normalized() * turn_force,
		$LeftPosition.global_transform.origin - self.global_transform.origin
	)
#	self.add_central_force(-self.global_transform.basis.z.normalized())

#	DebugDraw.draw_box(pos, Vector3(0.1, 0.1, 0.1), Color.blue)
#	DebugDraw.draw_box($PushPosition.global_transform.origin - self.global_transform.origin, Vector3(0.1, 0.1, 0.1), Color.blue)
	
	pass
