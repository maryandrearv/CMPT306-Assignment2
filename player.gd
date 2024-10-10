class_name Player extends CharacterBody2D

signal bullet_shot(bullet)
signal died

var rotation_speed = 3.0  # How fast the ship rotates
var movement_speed = 400.0  # How fast the ship moves forward/backward

var friction = 0.05  # Slow down over time when not thrusting

var shoot_cd = false
var rate_of_fire = 0.15

var alive := true

@onready var left_thruster = $LeftThruster
@onready var right_thruster = $RightThruster
@onready var anim = $AnimationPlayer
@onready var bullet_scene = preload("res://Bullet.tscn")  # Preload the bullet scene

@onready var muzzle = $Muzzle


# _process handles input for ship rotation and movement
func _physics_process(delta):
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

# _input handles firing the bullet
func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			fire_bullet()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

 # fire_bullet handles the instantiation of a bullet and sets its position and direction
func fire_bullet():
	var bullet = bullet_scene.instantiate()  # Instance a new bullet
	bullet.global_position = muzzle.global_position
	bullet.rotation = rotation  # Set the bullet's rotation to match the player's rotation
	emit_signal("bullet_shot", bullet)
	
func die():
	#pass
	if alive==true:
		alive = false
		#sprite.visible = false
		#cshape.set_deferred("disabled", true)
		emit_signal("died")
		queue_free()
