extends Node2D

@onready var bullets = $Bullets
@onready var player = $Player

func _ready():
	# Connect the "bullet_shot" signal from the player to the _on_bullet_shot function
	player.connect("bullet_shot", Callable(self, "_on_bullet_shot"))
	
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_bullet_shot(bullet):
	bullets.add_child(bullet)  # Correct method to add the bullet to the bullets node
	# Code to handle what happens when a bullet is shot
	print("Bullet has been shot")
