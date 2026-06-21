extends CharacterBody2D

const PROJETIL = preload("res://scenes/projetil_inimigo.tscn")

@export var tempo_entre_tiros := 1.2

var player_na_area := false
var pode_atirar := true
var atirando := false

var projeteis_ativos: Array = []
const MAX_PROJETEIS := 3

@onready var _animated_sprite = $AnimatedSprite2D
@onready var spawn_projetil: Marker2D = $SpawnProjetil

func _process(delta: float) -> void:
	if player_na_area and pode_atirar:
		atirar()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_na_area = true
		atirar()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_na_area = false

func atirar() -> void:
	if atirando:
		return

	if not player_na_area:
		return

	if not pode_criar_projetil():
		return

	atirando = true

	_animated_sprite.play("tiro")

	var fps = _animated_sprite.sprite_frames.get_animation_speed("tiro")
	var tempo_cooldown = 3.0 / fps

	while _animated_sprite.animation == "tiro" and _animated_sprite.frame < 3:
		await _animated_sprite.frame_changed

	criar_projetil()

	await get_tree().create_timer(tempo_cooldown).timeout

	atirando = false

	if player_na_area:
		atirar()
	
func criar_projetil() -> void:
	if not pode_criar_projetil():
		return

	var novo_projetil = PROJETIL.instantiate()
	novo_projetil.global_position = spawn_projetil.global_position

	if _animated_sprite.flip_h:
		novo_projetil.direcao = -1.0
		novo_projetil.scale.x = -1
	else:
		novo_projetil.direcao = 1.0
		novo_projetil.scale.x = 1

	get_tree().current_scene.add_child(novo_projetil)
	projeteis_ativos.append(novo_projetil)
	
func pode_criar_projetil() -> bool:
	projeteis_ativos = projeteis_ativos.filter(func(p): return is_instance_valid(p))
	return projeteis_ativos.size() < MAX_PROJETEIS
