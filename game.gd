extends Node2D

@onready var bullets = $Bullets
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var hud = $UI/HUD

var asteroid_scene = preload("res://asteroid.tscn")

var score := 0:
	set(value):
		score = value
		hud.score = score

var lives = 3


func _ready():
	score = 0
	lives = 3
	# Connect the "bullet_shot" signal from the player to the _on_bullet_shot function
	player.connect("bullet_shot", Callable(self, "_on_bullet_shot"))
	player.connect("died", Callable(self, "_on_player_died"))
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _on_bullet_shot(bullet):
	bullets.add_child(bullet)  # Correct method to add the bullet to the bullets node
	# Code to handle what happens when a bullet is shot
	print("Bullet has been shot")

func _on_asteroid_exploded(pos, size, points):
	score += points
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.LARGE:
				spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				pass
	print(score)
	
func spawn_asteroid(pos, size):
	var a = asteroid_scene.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)

func _on_player_died():
	lives -= 1
	if lives <= 0:
		get_tree().reload_current_scene()
	print(lives)
