extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FATOR_CRESCIMENTO = 1.1 # Crescimento de 10% ao colidir com inimigo
const FATOR_REDUCAO = 0.95 # Reduzir 5% é o mesmo que multiplicar por 0.95
const ESCALA_MAX = 2.5
const ESCALA_MIN = 0.5

# Referência para o Projétil (Arraste sua cena de tiro para cá no Inspetor)
@export var projetil_cena: PackedScene

var super_pulo = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Referência para o nó de animação
@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Aplica gravidade se não estiver no chão
	if not is_on_floor():
		velocity.y += gravity * delta

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

# Função responsável pelo tiro do Carnage (e diminuição do tamanho)
func atirar_e_encolher():
	# 1. Instancia o projétil
	if projetil_cena:
		var tiro = projetil_cena.instantiate()
		# Define a posição inicial do tiro
		tiro.global_position = global_position
		# Define a direção (baseado no flip do sprite)
		tiro.direction = -1 if _animated_sprite.flip_h else 1
		get_parent().add_child(tiro)

	# 2. Calcula e limita a nova escala (Mínimo de 0.5)
	var nova_escala = scale.x * FATOR_REDUCAO
	nova_escala = max(nova_escala, ESCALA_MIN)
	
	scale = Vector2(nova_escala, nova_escala)

# Função responsável pela destruição de inimigo e ativação da função de crescimento
func _on_body_entered(body: Node2D):
	if body.is_in_group("Inimigos"):
		# Destrói inimigo
		body.queue_free()
		
		# Cresce Carnage
		call_deferred("crescer_carnage")
		
		if not super_pulo:
			super_pulo = true
		
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

func _on_animated_sprite_2d_animation_looped() -> void:
	pass
