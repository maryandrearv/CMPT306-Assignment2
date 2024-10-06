extends Area2D

var speed = 400.0  # Bullet speed
var direction = Vector2()  # Bullet's movement direction

func _ready():
	# Automatically delete the bullet after 2 seconds
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _physics_process(delta):
	# Move the bullet forward
	position += direction * speed * delta

func set_direction(new_direction: Vector2):
	direction = new_direction
