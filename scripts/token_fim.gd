extends Node2D

@onready var area = $Area2D
@onready var sprite = $AnimatedSprite2D

var ativado := false

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if ativado:
		return

	if body.is_in_group("Player"):
		ativado = true

		sprite.play("fim")

		await sprite.animation_finished

		get_tree().change_scene_to_file("res://scenes/menu.tscn")
