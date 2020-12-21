extends RigidBody

onready var wheelRayCast: RayCast = $WheelRayCast

var restLength: float = 1
var springTravel: float = 1
var springStiffness: float = 100
var damperStiffness: float = 5
var wheelRadius: float = 0.1

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
	
	print("minLength", minLength)
	print("maxLength", maxLength)

func _physics_process(delta):
	var wheelRayCastPosition = wheelRayCast.global_transform.origin;
	
	if (wheelRayCast.is_colliding()):	
		var hitPosition = wheelRayCast.get_collision_point()
		
		lastLength = springLength
		
		springLength = wheelRayCastPosition.distance_to(hitPosition)
		
		springLength = clamp(springLength, minLength, maxLength)
		
		springVelocity = (lastLength - springLength) / delta
		
		springForce = springStiffness * (restLength - springLength)
		
		damperForce = damperStiffness * springVelocity
		
		suspensionForce = (springForce + damperForce) * Vector3.UP
		
		self.add_force(suspensionForce, self.to_local(wheelRayCast.global_transform.origin))

