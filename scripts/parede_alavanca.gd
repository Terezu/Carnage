extends Node2D

@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func quebrar():
	animacao()
	await get_tree().create_timer(1.0).timeout
	queue_free()

func animacao():
		sprite.play("ativar")
