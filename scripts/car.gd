extends VehicleBody3D

var suspention_stiffness = 100.0
var suspention_travel = 0.2
var damping_compression = 0.8
var damping_relaxation = 1
var steering_angle = deg_to_rad(20)
var steering_speed = 5.0
var engine_max_rpm = 800.0
var engine_max_torque = 300.0

@onready var wheels = [$FrontLeftWheel,$FrontRightWheel,$BackLeftWheel,$BackRightWheel]
@onready var rpm_wheel = $BackLeftWheel
@onready var restart_canvas = $"../../CanvasLayer"
@onready var car_label = $"../../CanvasLayer2/Control/RPMLabel"
@onready var crash_audio = $CrashAudio
@onready var engine_audio = $EngineAudio

var _car_hit = false

func _ready():
    mass = 100
    for wheel in wheels:
        _set_wheel_params(wheel)
    body_entered.connect(_on_body_entered)
    restart_canvas.hide()

func _process(delta: float):
    if Input.is_key_pressed(KEY_R):
        get_tree().reload_current_scene()

    var steering_input = Input.get_axis("ui_left", "ui_right")
    var acceleration_input = Input.get_axis("ui_down", "ui_up")

    steering = lerp(steering, -steering_input * steering_angle, steering_speed * delta)
    var rpm = 0

    if acceleration_input == 0:
        engine_force = 0
        brake = 2
    else:
        rpm = 1 - rpm_wheel.get_rpm() / engine_max_rpm
        brake = 0
        engine_force = acceleration_input * rpm * engine_max_torque

    if Input.is_key_pressed(KEY_SPACE):
        brake = 15

    car_label.text = "RPM: %s\nVEL: %s km/h" % [round(rpm*engine_max_rpm), floor(linear_velocity.length())]
    engine_audio.pitch_scale = lerp(engine_audio.pitch_scale, 1+acceleration_input/2.0, steering_speed * delta)

func _set_wheel_params(wheel: VehicleWheel3D):
    wheel.suspension_stiffness = suspention_stiffness
    wheel.suspension_travel = suspention_travel
    wheel.damping_compression = damping_compression
    wheel.damping_relaxation = damping_relaxation

func _on_body_entered(body):
    if not _car_hit:
        print("hit", body.name)
        restart_canvas.show()
        crash_audio.play()
        _car_hit = true
