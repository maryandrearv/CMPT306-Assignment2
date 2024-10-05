extends CharacterBody2D

var rotation_speed = 3.0

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta
	elif Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
