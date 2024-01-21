extends VehicleBody3D

var suspention_stiffness = 100.0
var suspention_travel = 0.2
var damping_compression = 0.8
var damping_relaxation = 1
var steering_angle = deg_to_rad(20)
var steering_speed = 5.0
var engine_max_rpm = 800.0
var engine_max_torque = 200.0

@onready var wheels = [$FrontLeftWheel, $FrontRightWheel, $BackLeftWheel, $BackRightWheel]
@onready var rpm_wheel = $BackLeftWheel
@onready var restart_canvas = $"../../CanvasLayer"
@onready var car_label = $"../../CanvasLayer2/Control/RPMLabel"
@onready var crash_audio = $CrashAudio
@onready var engine_audio = $EngineAudio
@onready var cameras: Array = [$"../CameraTop", $"../CameraBent", $"../CameraSide", $CameraCar, $CameraCar2]
@onready var cameras_parents: Array = [$"..", $"..", $"..", self, self]

var _car_hit = false
static var _camera = 0

func _ready():
    mass = 100
    for wheel in wheels:
        _set_wheel_params(wheel)
    body_entered.connect(_on_body_entered)
    restart_canvas.hide()
    _set_camera(_camera)

func _process(delta: float):
    if Input.is_action_just_pressed("reset"):
        get_tree().reload_current_scene()

    if Input.is_action_just_pressed("camera"):
        _camera+=1
        _set_camera(_camera)

    var steering_input = Input.get_axis("steer_left", "steer_right")
    var acceleration_input = Input.get_axis("backward", "forward")

    steering = lerp(steering, -steering_input * steering_angle, steering_speed * delta)
    var rpm = 0

    if acceleration_input == 0:
        engine_force = 0
        brake = 2
    else:
        rpm = 1 - rpm_wheel.get_rpm() / engine_max_rpm
        brake = 0
        engine_force = acceleration_input * rpm * engine_max_torque

    if Input.is_action_pressed("brake"):
        brake = 15

    car_label.text = "RPM: %s\nVEL: %s km/h" % [round(rpm*engine_max_rpm), floor(linear_velocity.length())]
    engine_audio.pitch_scale = lerp(engine_audio.pitch_scale, 1+acceleration_input/2.0, steering_speed * delta)

func _set_wheel_params(wheel: VehicleWheel3D):
    wheel.suspension_stiffness = suspention_stiffness
    wheel.suspension_travel = suspention_travel
    wheel.damping_compression = damping_compression
    wheel.damping_relaxation = damping_relaxation
    if wheel.position.x > 0:
        wheel.position.x = 0.9
    else:
        wheel.position.x = -0.9

func _on_body_entered(body):
    if not _car_hit:
        print("hit", body.name)
        restart_canvas.show()
        crash_audio.play()
        _car_hit = true

func _set_camera(id):
    id = id % cameras.size()
    for i in range(cameras.size()):
        if i == id:
            if cameras[i].get_parent() != cameras_parents[i]:
                cameras_parents[i].add_child(cameras[i])
        elif cameras[i].get_parent() == cameras_parents[i]:
            cameras_parents[i].remove_child.call_deferred(cameras[i])


