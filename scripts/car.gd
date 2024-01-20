extends VehicleBody3D

var suspention_stiffness = 100.0
var suspention_travel = 0.2
var damping_compression = 0.3
var damping_relaxation = 0.5

@onready var wheels = [$FrontLeftWheel,$FrontRightWheel,$BackLeftWheel,$BackRightWheel]

func _ready():
    for wheel in wheels:
        _set_wheel_params(wheel)

func _process(delta: float):
    steering = Input.get_axis("ui_left", "ui_right") * 0.4
    engine_force = Input.get_axis("ui_down", "ui_up") * 100

func _set_wheel_params(wheel: VehicleWheel3D):
    wheel.suspension_stiffness = suspention_stiffness
    wheel.suspension_travel = suspention_travel
    wheel.damping_compression = damping_compression
    wheel.damping_relaxation = damping_relaxation
