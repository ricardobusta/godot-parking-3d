extends VehicleBody3D

var suspention_stiffness = 100.0
var suspention_travel = 0.2
var damping_compression = 0.3
var damping_relaxation = 0.5
var steering_angle = deg_to_rad(30)
var steering_speed = 5.0
var engine_max_rpm = 800.0
var engine_max_torque = 300.0

@onready var wheels = [$FrontLeftWheel,$FrontRightWheel,$BackLeftWheel,$BackRightWheel]
@onready var rpm_wheel = $BackLeftWheel

func _ready():
    mass = 100
    for wheel in wheels:
        _set_wheel_params(wheel)

func _process(delta: float):
    if Input.is_key_pressed(KEY_R):
        get_tree().reload_current_scene()

    var steering_input = Input.get_axis("ui_left", "ui_right")
    var acceleration_input = Input.get_axis("ui_down", "ui_up")

    steering = lerp(steering, -steering_input * steering_angle, steering_speed * delta)

    if acceleration_input == 0:
        engine_force = 0
        brake = 2
    else:
        var rpm = 1 - rpm_wheel.get_rpm() / engine_max_rpm
        brake = 0
        engine_force = acceleration_input * rpm * engine_max_torque

func _set_wheel_params(wheel: VehicleWheel3D):
    wheel.suspension_stiffness = suspention_stiffness
    wheel.suspension_travel = suspention_travel
    wheel.damping_compression = damping_compression
    wheel.damping_relaxation = damping_relaxation
