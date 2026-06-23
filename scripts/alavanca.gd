extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

@export var parede: Node2D

var player_na_area: bool = false
var ativada: bool = false

func _ready() -> void:
	print("NÓ ATUAL:", self.name)
	print("FILHOS:", get_children())
	print("SPRITE:", animated_sprite)

func _process(_delta: float) -> void:
	if player_na_area and Input.is_action_just_pressed("Ação") and not ativada:
		ativar_alavanca()

func ativar_alavanca() -> void:
	ativada = true
	animated_sprite.play("ativar")
	
	if parede:
		print("PAREDE ENCONTRADA:", parede.name)
		parede.quebrar()
	print("ALAVANCA ATIVADA")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_na_area = true
		print("PLAYER ENTROU NA ALAVANCA")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_na_area = false
		print("PLAYER SAIU DA ALAVANCA")
