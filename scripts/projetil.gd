extends Area2D

var velocidade: float = 500.0
var direcao: float = 1.0

func _process(delta: float) -> void:
	# Ajusta a orientação do tiro
	position.x += velocidade * direcao * delta
	
# Função responsável pela colisão com inimigos
func _on_area_entered(area: Node2D) -> void:
	# Se bater em um, inimigo, aplica lógica de dano
	if area.is_in_group("inimigos"):
		area.queue_free()
		
	if area.is_in_group("Quebravel"):
		area.quebrar()
		# Destrói o projétil
		queue_free()

# Destrói o projétil uma vez que ele não esteja mais visível
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
	
