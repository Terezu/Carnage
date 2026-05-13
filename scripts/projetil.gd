extends Area2D

var velocidade = 500
var direcao = 1

func _process(delta):
	position.x += velocidade * delta
	
func _on_screeexited():
	queue_free()
