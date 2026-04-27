extends CharacterBody2D


var PROJETIL_SCENE = preload("res://scenes/projetil.tscn")
var player_na_area = false

func _on_area_2d_body_entered(body):
	if body.name == "Carnage": # Verifica se é o jogador
		player_na_area = true
		atirar()

func _on_area_2d_body_exited(body):
	if body.name == "Carnage":
		player_na_area = false
		

func atirar():
	if player_na_area:
		var novo_tiro = PROJETIL_SCENE.instantiate()
		
		# Adiciona o tiro à raiz da cena
		get_tree().current_scene.add_child(novo_tiro)
		
		# Define a posição de saída do tiro
		novo_tiro.global_position = self.global_position
