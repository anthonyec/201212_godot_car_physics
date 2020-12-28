extends Spatial

export var stiffness: float = 50
export var mass: float = 1
export var damping: float = 2
export var springLength: float = 50
export var clamp_spring: bool = false
export var min_clamp: float = -10
export var max_clamp: float = 10

#/* Object position and velocity. */
var value = 0
var v = 0

#/* Spring stiffness, in kg / s^2 */
var k = -stiffness

#/* Framerate: we want 60 fps hence the framerate here is at 1/60 */
var frameRate: float = 0.016666667 # can't do calculation when initalising?

var d = -damping

func _ready():
	pass

func _process(delta):
	var Fspring = k * (value - springLength)
	var Fdamping = d * v
	var a = (Fspring + Fdamping) / mass

	v += a * frameRate
	value += v * frameRate
	
	if clamp_spring and value < min_clamp:
		value = min_clamp
		v = 0
		
	if clamp_spring and value > max_clamp:
		value = max_clamp
		v = 0
	
func add_velocity(velocity: float):
	v += velocity
