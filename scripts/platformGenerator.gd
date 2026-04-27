extends Node2D

@export var modelos_plataforma: Array[PackedScene]

func _ready() -> void:
	gerar_plataforma_aleatoria()

func gerar_plataforma_aleatoria():
	if modelos_plataforma.size() == 0:
		return
	
	var indice_aleatorio = randi() % modelos_plataforma.size()
	
	var cena_escolhida = modelos_plataforma[indice_aleatorio]
	
	var nova_plataforma = cena_escolhida.instantiate()
	
	add_child(nova_plataforma)
