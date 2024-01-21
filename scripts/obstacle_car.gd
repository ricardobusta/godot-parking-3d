extends VehicleBody3D

var suspention_stiffness = 100.0
var suspention_travel = 0.2
var damping_compression = 0.8
var damping_relaxation = 1
var steering_angle = deg_to_rad(20)
var steering_speed = 5.0
var engine_max_rpm = 800.0
var engine_max_torque = 300.0

@onready var wheels = [$FrontLeftWheel, $FrontRightWheel, $BackLeftWheel, $BackRightWheel]

func _ready():
    mass = 100
    brake = 10
    for wheel in wheels:
        _set_wheel_params(wheel)

func _set_wheel_params(wheel: VehicleWheel3D):
    if wheel.position.x > 0:
        wheel.position.x = 0.5
    else:
        wheel.position.x = -0.5
    wheel.suspension_stiffness = suspention_stiffness
    wheel.suspension_travel = suspention_travel
    wheel.damping_compression = damping_compression
    wheel.damping_relaxation = damping_relaxation
