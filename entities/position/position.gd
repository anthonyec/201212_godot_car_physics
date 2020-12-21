extends Spatial

func _process(_delta):
	if !self.visible:
		return
	
	DebugDraw.draw_line_3d(
		self.global_transform.origin,
		self.global_transform.origin + Vector3.FORWARD * 10, 
		Color.blue
	)
	
	DebugDraw.draw_line_3d(
		self.global_transform.origin,
		self.global_transform.origin + Vector3.RIGHT * 10, 
		Color.red
	)
	
	DebugDraw.draw_line_3d(
		self.global_transform.origin,
		self.global_transform.origin + Vector3.UP * 10, 
		Color.green
	)
