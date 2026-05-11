extends Control

var fases = [
	"res://scenes/1-1.tscn",
	"res://scenes/1-2.tscn",
	"res://scenes/1-3.tscn"
]

func _on_start_button_pressed():
	# Gera um número aleatório
	randomize()
	
	# Sorteia um número dentro do número de conteúdo do array de fases
	var indice_sorteado = randi() % fases.size()
	
	# Associa o número sorteado à fase respectiva do array
	var fase_escolhida = fases[indice_sorteado]
	
	# Vai para a fase sorteada
	get_tree().change_scene_to_file(fase_escolhida)
	
func _on_quit_button_pressed():
	get_tree().quit()
