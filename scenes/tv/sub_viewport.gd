extends SubViewport

@onready var camera_2d: Camera2D = $Camera2D
var speed: float = 100.0


func _ready() -> void:
	$Demo/Player2D/Camera2D.zoom = Vector2(1.0, 1.0)
	#camera_2d.position.x = 128
	#camera_2d.position.y = 122


func _physics_process(delta: float) -> void:
	camera_2d.position.x += delta*speed
	if camera_2d.position.x > (3554-128):
		camera_2d.position.x = 122
