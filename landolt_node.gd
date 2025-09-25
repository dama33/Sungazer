extends Node2D

@onready var sprite: Sprite2D
var landolt = load("res://assets/Landolt Up.png")

func _ready():
	rotation = deg_to_rad(randi()%4 * 90)
