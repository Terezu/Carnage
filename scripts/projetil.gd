extends Area2D

var velocidade: float = 500.0
var direcao: float = 1.0

func _process(delta: float) -> void:
	# Ajusta a orientação do tiro
	position.x += velocidade * direcao * delta
	
# Função responsável pela colisão com o player
func _on_area_entered(area: Node2D) -> void:
	# print("COLIDI COM:", area.name)
	# print("GRUPOS:", area.get_groups())
	
	if area.is_in_group("Player"):
		area.queue_free()
		queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()	
