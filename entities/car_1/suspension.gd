extends RayCast

onready var rb: RigidBody = self.get_parent()

onready var wheel = $Wheel

var restLength: float = 2
var springTravel: float = 2
var springStiffness: float = 400
var damperStiffness: float = 390
var wheelRadius: float = 0.2

var minLength: float
var maxLength: float
var springLength: float
var springVelocity: float
var lastLength: float
var springForce: float
var damperForce: float

var suspensionForce: Vector3

func _ready():
	minLength = restLength - springTravel
	maxLength = restLength + springTravel
	pass

func _physics_process(delta):
	var wheelRayCastPosition = self.global_transform.origin;
	var forceLocation = self.global_transform.origin - rb.global_transform.origin
	
	DebugDraw.draw_box(rb.global_transform.origin + forceLocation, Vector3(0.2, 0.2, 0.2), Color.red)
	
	if (!self.is_colliding()):
		DebugDraw.draw_line_3d(self.global_transform.origin, self.global_transform.origin - global_transform.basis.y * 1, Color.white)

			
	if (self.is_colliding()):	
		var hitPosition = self.get_collision_point()
		
		DebugDraw.draw_line_3d(self.global_transform.origin, self.global_transform.origin - global_transform.basis.y * springLength, Color.red)
		
		lastLength = springLength
		
		springLength = wheelRayCastPosition.distance_to(hitPosition)
		
		springLength = clamp(springLength, minLength, maxLength)
		
		springVelocity = (lastLength - springLength) / delta
		
		springForce = springStiffness * (restLength - springLength)
		
		damperForce = damperStiffness * springVelocity
		
		suspensionForce = (springForce + damperForce) * self.global_transform.basis.y.normalized()
		
#		Vector3.UP 
		
		wheel.transform.origin.y = (-springLength) + wheelRadius
		
		var force = suspensionForce
		
		DebugDraw.draw_ray_3d(
			rb.global_transform.origin + forceLocation, 
			suspensionForce.normalized(),
			2,
			Color.blue
		)
		
		rb.add_force(force, forceLocation)

