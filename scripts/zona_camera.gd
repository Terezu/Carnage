extends Area2D

@export var prioridade := 0

@onready var collision: CollisionShape2D = $CollisionShape2D

func contem_ponto(ponto: Vector2) -> bool:
	var rect := collision.shape as RectangleShape2D
	var centro := collision.global_position
	var metade := rect.size / 2.0

	var left := centro.x - metade.x
	var right := centro.x + metade.x
	var top := centro.y - metade.y
	var bottom := centro.y + metade.y

	return ponto.x >= left and ponto.x <= right and ponto.y >= top and ponto.y <= bottom

func pegar_limites() -> Dictionary:
	var rect := collision.shape as RectangleShape2D
	var centro := collision.global_position
	var metade := rect.size / 2.0

	return {
		"left": int(centro.x - metade.x),
		"right": int(centro.x + metade.x),
		"top": int(centro.y - metade.y),
		"bottom": int(centro.y + metade.y)
	}
