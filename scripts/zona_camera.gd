extends Area2D

@onready var shape: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		aplicar_limites(body)

func aplicar_limites(player: Node2D) -> void:

	var rect_shape = shape.shape as RectangleShape2D

	var tamanho = rect_shape.size
	var centro = global_position

	var left = centro.x - tamanho.x / 2
	var right = centro.x + tamanho.x / 2

	var top = centro.y - tamanho.y / 2
	var bottom = centro.y + tamanho.y / 2

	player.aplicar_limites_camera(
		int(left),
		int(right),
		int(top),
		int(bottom)
	)
