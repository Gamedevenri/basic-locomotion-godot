extends SpringArm3D

var mouse_sens:float = 0.005

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sens
		
		rotation.x -= event.relative.y * mouse_sens
	
	if event.is_action_pressed("wheel up"):
		spring_length -= 1
	if event.is_action_pressed("wheel down"):
		spring_length += 1
