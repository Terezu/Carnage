extends Node2D

@export var fases = [
	"res://scenes/2-1.tscn",
	"res://scenes/2-2.tscn",
	"res://scenes/3-1.tscn",
	"res://scenes/3-2.tscn",
]

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Gera um número aleatório
		randomize()
		
		# Sorteia um número dentro do número de conteúdo do array de fases
		var indice_sorteado = randi() % fases.size()
		
		# Associa o número sorteado à fase respectiva do array
		var fase_escolhida = fases[indice_sorteado]
		
		# Vai para a fase sorteada
		get_tree().change_scene_to_file(fase_escolhida)
