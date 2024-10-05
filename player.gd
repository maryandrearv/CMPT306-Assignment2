extends CharacterBody2D

var rotation_speed = 3.0
@onready var left_thruster = $LeftThruster
@onready var right_thruster = $RightThruster
@onready var anim = $AnimationPlayer

func _process(delta):
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
