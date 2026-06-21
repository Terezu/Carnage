extends Area2D

@export var velocidade := 300.0
@export var dano := 1

var direcao := 1.0

func _process(delta: float) -> void:
	position.x += direcao * velocidade * delta

func _on_body_entered(body: Node2D) -> void:
	print("Bateu em:", body.name)
	if body.is_in_group("Player"):
		if body.has_method("receber_dano"):
			body.receber_dano(dano)

		queue_free()
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()	
