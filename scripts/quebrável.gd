extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var colisao_parede: CollisionShape2D = $"../CollisionShape2D"

func quebrar():
	colisao_parede.set_deferred("disabled", true)

	sprite.play("desfazer")
	await sprite.animation_finished

	queue_free()
