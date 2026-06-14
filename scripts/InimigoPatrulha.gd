extends CharacterBody2D

@export var velocidade_patrulha = 150.0
@export var distancia_patrulha = 250.0
@export var gravidade = 980.0
@export var velocidade_perseguicao = 125.0
@export var jump = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_na_area = null
var direcao = 1.0
var ponto_inicial: Vector2
var pode_inverter = true 
var tempo_perseguicao = 0.0
var can_jump = true
var estava_no_ar := false
var tempo_entre_pulos := 0.5
var esperando_proximo_pulo := false

@onready var sensor_chao = $RayCast2D
# Adicione a referência ao sprite
@onready var sprite = $AnimatedSprite2D 

enum EstadoPulo {
	CHAO,
	PREPARANDO,
	SUBINDO,
	CAINDO,
	ESPERANDO
}

var estado_pulo = EstadoPulo.CHAO

func _ready():
	ponto_inicial = global_position
	sensor_chao.add_exception(self)
	sprite.animation_finished.connect(_on_sprite_animation_finished)
	
func _physics_process(delta):	
	if direcao > 0:
		$AnimatedSprite2D.flip_h = false
	elif direcao < 0:
		$AnimatedSprite2D.flip_h = true
		
	# Prioridade de execução de funções
	if player_na_area and is_instance_valid(player_na_area):
		movimentacao_perseguicao()
	else:
		movimentacao_patrulha()
	
	if not is_on_floor():
		velocity.y += gravidade * delta

	if is_on_floor() and can_jump and estado_pulo == EstadoPulo.CHAO and not esperando_proximo_pulo:
		iniciar_preparacao_pulo()

	move_and_slide()

	if not is_on_floor():
		estava_no_ar = true
		
		if velocity.y < 0:
			estado_pulo = EstadoPulo.SUBINDO
		else:
			estado_pulo = EstadoPulo.CAINDO

	if is_on_floor() and estava_no_ar and not esperando_proximo_pulo:
		estava_no_ar = false
		estado_pulo = EstadoPulo.CHAO
		esperando_proximo_pulo = true
		esperar_proximo_pulo()
		
	# Atualiza animação de pulo
	atualizar_animacao()

func movimentacao_perseguicao():
	# Variável para perseguição
	var direcao_para_player = sign(player_na_area.global_position.x - global_position.x)
	
	velocity.x = direcao_para_player * velocidade_perseguicao
	
	# Trava no abismo
	if not sensor_chao.is_colliding():
		velocity.x = 0
	
	if tempo_perseguicao <= 0:
		# Sincroniza a viriável para caso o player fuja
		direcao = direcao_para_player
		# Garante que o sensor de abismo acompanhe direcionado ao lado que estiver olhando
		sensor_chao.position.x = abs(sensor_chao.position.x) * direcao

func movimentacao_patrulha():
	velocity.x = direcao * velocidade_patrulha
	
	if is_on_floor():
		if (is_on_wall() or not sensor_chao.is_colliding()) and pode_inverter:
			if not sensor_chao.is_colliding():
				print("SEM CHÃO")
			
			if is_on_wall():
				print("PAREDE")
				
			inverter_direcao()
			print("INVERTEU")
			ponto_inicial.x = global_position.x
			
	var distancia_atual = abs(global_position.x - ponto_inicial.x)
	
	if distancia_atual >= distancia_patrulha and pode_inverter:
		inverter_direcao()

# Função de inversão de movimento
func inverter_direcao():
	pode_inverter = false
	direcao *= -1
	
	# Sincroniza o sensor para a nova direção
	sensor_chao.position.x = abs(sensor_chao.position.x) * direcao
	
	await get_tree().create_timer(0.2).timeout
	pode_inverter = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_na_area = body
		
func _on_area_2d_body_exited(body):
	if body == player_na_area:
		player_na_area = null
		# Quando player sai da área, reinicia patrulha
		ponto_inicial = global_position
		
func iniciar_pulo():
	can_jump = false
	velocity.y = jump
	sprite.play("jump_incoming")

func atualizar_animacao():
	if estado_pulo == EstadoPulo.PREPARANDO:
		return

	if not is_on_floor():
		if velocity.y < 0:
			if sprite.animation != "jumping":
				sprite.play("jumping")
		else:
			if sprite.animation != "jumping_after":
				sprite.play("jumping_after")
	else:
		if estado_pulo == EstadoPulo.CHAO:
			if abs(velocity.x) > 0:
				if sprite.animation != "walk":
					sprite.play("walk")
			else:
				if sprite.animation != "idle":
					sprite.play("idle")

func iniciar_preparacao_pulo():
	can_jump = false
	estado_pulo = EstadoPulo.PREPARANDO
	velocity.x = 0
	sprite.play("jump_incoming")
	
func _on_sprite_animation_finished():
	if sprite.animation == "jump_incoming":
		velocity.y = jump
		estado_pulo = EstadoPulo.SUBINDO
		sprite.play("jumping")

func esperar_proximo_pulo():
	await get_tree().create_timer(tempo_entre_pulos).timeout
	can_jump = true
	esperando_proximo_pulo = false
