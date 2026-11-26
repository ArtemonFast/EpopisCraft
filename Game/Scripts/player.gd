extends CharacterBody3D

@export_category("Movement")
@export var SPEED: float = 2.0
@export var SENSITIVITY: float = 0.003
@export var acceleration: float = 7.5
@export var JUMP_VELOCITY: int = 5
@export var GRAVITY: int = 10
var moveDir: Vector3 = Vector3.ZERO

@onready var head = $Head
@onready var camera: Camera3D = $Head/Camera3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_foward", "move_back")
	moveDir = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if moveDir:
		velocity.x = moveDir.x * SPEED
		velocity.z = moveDir.z * SPEED
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	velocity.x = lerpf(velocity.x, moveDir.x * SPEED, acceleration * delta)
	velocity.z = lerpf(velocity.z, moveDir.z * SPEED, acceleration * delta)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-75), deg_to_rad(90))
