extends CharacterBody2D

var rotation_speed = 3.0  # How fast the ship rotates
var movement_speed = 400.0  # How fast the ship moves forward/backward
var friction = 0.05  # Slow down over time when not thrusting

@onready var left_thruster = $LeftThruster
@onready var right_thruster = $RightThruster
@onready var anim = $AnimationPlayer

func _process(delta):
	# Handle Rotation
	if Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta
		anim.play("rotate_right")
		right_thruster.visible = true  # Show right thruster
		left_thruster.visible = false  # Hide left thruster
	elif Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
		anim.play("rotate_left")
		left_thruster.visible = true  # Show left thruster
		right_thruster.visible = false  # Hide right thruster
	else:
		anim.stop()
		left_thruster.visible = false  # Hide both thrusters when not rotating
		right_thruster.visible = false

	# Handle Forward and Backward Movement
	if Input.is_action_pressed("ui_up"):
		var thrust_direction = Vector2(movement_speed, 0).rotated(rotation)  # Move in the direction the ship is facing
		velocity += thrust_direction * delta  # Apply thrust for forward movement
	elif Input.is_action_pressed("ui_down"):
		var backward_direction = Vector2(-movement_speed, 0).rotated(rotation)  # Move in the opposite direction
		velocity += backward_direction * delta  # Apply thrust for backward movement
	else:
		# Apply friction to slow the ship down gradually when no input is pressed
		velocity = velocity.move_toward(Vector2.ZERO, friction * movement_speed)

	# Apply movement using CharacterBody2D's velocity with move_and_slide
	move_and_slide()
