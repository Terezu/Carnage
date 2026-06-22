extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FATOR_CRESCIMENTO = 1.1 # Crescimento de 10% ao colidir com inimigo
const FATOR_REDUCAO = 0.95 # Reduzir 5% é o mesmo que multiplicar por 0.95
const ESCALA_MAX = 2.5
const ESCALA_MIN = 0.5

const PROJETIL = preload("res://scenes/projetil.tscn")

# Referência para o Projétil
@export var projetil_cena: PackedScene

var vida := 3

var super_pulo = false
var habilidade_tiro = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Referência para limitação da câmera
@onready var camera: Camera2D = $Camera2D

var zona_camera_atual: Area2D = null

# Referência para o nó de animação
@onready var _animated_sprite = $AnimatedSprite2D

# Referência para o ponto de onde o tiro vai sair
@onready var spawn_projetil: Marker2D = $SpawnProjetil

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	atualizar_zona_camera()
	
	# Aplica gravidade se não estiver no chão
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("Atirar"):
		atirar()

	# Lógica do pulo
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		if super_pulo == true:
			velocity.y *= 2 # Corrigido para afetar apenas o eixo Y do pulo
 
	# Movimentação simples
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# Controle de Animação
	atualizar_animacao(direction)

func atualizar_animacao(direction):
	if not is_on_floor():
		_animated_sprite.play("jump")
	elif direction != 0:
		_animated_sprite.play("walk")
		# Inverte o sprite baseado na direção
		_animated_sprite.flip_h = (direction < 0)
	else:
		_animated_sprite.play("idle")

# Função responsável pela destruição de inimigo e ativação da função de crescimento
func _on_body_entered(body: Node2D):
	if body.is_in_group("Inimigos"):
		# Destrói inimigo
		body.queue_free()
		
		# Cresce Carnage
		call_deferred("crescer_carnage")
		
		if not super_pulo:
			super_pulo = true
			
		if body.is_in_group("InimigoTiro"):
			if not habilidade_tiro:
				habilidade_tiro = true
		
# Função responsável pelo crescimento do Carnage
func crescer_carnage():
	# Pegamos a altura antiga antes de crescer
	var altura_antiga = $CollisionShape2D.shape.get_rect().size.y * scale.y
	
	# Calcula nova escala com limite máximo de 2.5 em relação ao tamanho original
	var nova_escala = scale.x * FATOR_CRESCIMENTO
	nova_escala = min(nova_escala, ESCALA_MAX)
	
	# Atualiza a escala
	scale = Vector2(nova_escala, nova_escala)
	
	# Pegamos a nova altura
	var nova_altura = $CollisionShape2D.shape.get_rect().size.y * scale.y
	
	# Calculamos a diferença e subimos o personagem exatamente essa diferença
	# Para que ele cresça a partir dos pés
	global_position.y -= (nova_altura - altura_antiga) / 2

func atirar() -> void:
	# Validação de que não é possível atirar após atingir o tamanho mínimo
	if scale.x <= ESCALA_MIN:
		return
	
	if habilidade_tiro == true:
		# Instância o scene do projétil
		var novo_projetil = PROJETIL.instantiate()
		
		# Define a posição e rotação de origem do projetil
		novo_projetil.global_position = spawn_projetil.global_position
		
		# Lógica que ajusta a direção do tiro
		if _animated_sprite.flip_h:
			novo_projetil.direcao = -1.0
			novo_projetil.scale.x = -1
		else:                                           # O scale serve para "flipar"
			novo_projetil.direcao = 1.0                  # desenho do projetil
			novo_projetil.scale.x = 1

		# Adiciona o projétil à cena onde é chamado, ativando ele
		get_tree().current_scene.add_child(novo_projetil)
		
		# Pega a escala atual do Carnage e aplica a redução de tamanho após atirar
		var nova_escala = scale.x * FATOR_REDUCAO
		
		# Garante que o Carnage não ultrapasse o tamanho mínimo
		nova_escala = max(nova_escala, ESCALA_MIN)
		
		# Aplica o novo tamanho
		scale = Vector2(nova_escala, nova_escala)

func _on_animated_sprite_2d_animation_looped() -> void:
	pass
	
func receber_dano(valor: int) -> void:
	modulate.a = 0.3
	await get_tree().create_timer(0.1).timeout
	modulate.a = 1.0
	vida -= valor
	print("Player tomou dano. Vida atual:", vida)

	if vida <= 0:
		morrer()

func morrer() -> void:
	print("Player morreu")
	queue_free()

func aplicar_limites_camera(left: int, right: int, top: int, bottom: int) -> void:
	camera.limit_left = left
	camera.limit_right = right
	camera.limit_top = top
	camera.limit_bottom = bottom
	
func atualizar_zona_camera() -> void:
	var melhor_zona: Area2D = null

	for zona in get_tree().get_nodes_in_group("cameras"):
		if zona.contem_ponto(global_position):
			if melhor_zona == null or zona.prioridade > melhor_zona.prioridade:
				melhor_zona = zona

	if melhor_zona != null and melhor_zona != zona_camera_atual:
		zona_camera_atual = melhor_zona
		aplicar_limites_da_zona(melhor_zona)
		
func aplicar_limites_da_zona(zona: Area2D) -> void:
	var limites = zona.pegar_limites()

	camera.limit_left = limites["left"]
	camera.limit_right = limites["right"]
	camera.limit_top = limites["top"]
	camera.limit_bottom = limites["bottom"]

	print("Zona atual:", zona.name)
