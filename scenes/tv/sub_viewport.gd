extends SubViewport

@onready var camera_2d: Camera2D = $Camera2D
var speed: float = 100.0


func _ready() -> void:
	camera_2d.position.x = 128
	camera_2d.position.y = 122


func _physics_process(delta: float) -> void:
	camera_2d.position.x += delta*speed
	if camera_2d.position.x > 3500:
		camera_2d.position.x = 122
