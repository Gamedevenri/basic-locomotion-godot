extends CharacterBody3D


var SPEED = 2.0
const JUMP_VELOCITY = 4.5

var animsvec:Vector2
var currvec:Vector2
var shift:bool

@onready var anims = $AnimationTree

func _input(event):
	if Input.is_action_pressed("shift"):
		shift = true
	else:
		shift = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("d", "a", "s", "w")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, 0.05)
		velocity.z = lerp(velocity.z, direction.z * SPEED, 0.05)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.05)
		velocity.z = lerp(velocity.z, 0.0, 0.05)


	if not shift:
		SPEED = 2.0
		anims.set("parameters/Transition/transition_request", "walk")
		var blendpos = anims.get("parameters/walk/blend_position")
		animsvec = Vector2(input_dir.x, input_dir.y).normalized()
		currvec = currvec.move_toward(-animsvec, 4*delta)
		anims.set("parameters/walk/blend_position", lerp(blendpos,Vector2(currvec.x, -currvec.y), 0.1))
	elif shift:
		SPEED = 5.0
		anims.set("parameters/Transition/transition_request", "run")
		animsvec = Vector2(input_dir.x, input_dir.y).normalized()
		currvec = currvec.move_toward(-animsvec, 4*delta)
		var blendpos = anims.get("parameters/run/blend_position")
		anims.set("parameters/run/blend_position", lerp(blendpos,Vector2(currvec.x, -currvec.y), 0.1)) 

	move_and_slide()
