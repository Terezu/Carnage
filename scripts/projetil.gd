extends Area2D
var velocidade = -400

func _process(delta):
	position.x += velocidade * delta
