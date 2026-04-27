extends CharacterBody2D

@export var velocidade_patrulha = 100.0
@export var distancia_patrulha = 200.0
@export var gravidade = 980.0
@export var velocidade_perseguicao = 125.0

var player_na_area = null
var direcao = 1
var ponto_inicial: Vector2
var pode_inverter = true 
var tempo_perseguicao = 0.0

@onready var sensor_chao = $RayCast2D
# Adicione a referência ao sprite (necessário troca de nome quando tiver sprite)
# @onready var sprite = $Sprite2D 

func _ready():
	ponto_inicial = global_position
	sensor_chao.add_exception(self) 
	
func _physics_process(delta):
	# Gravidade com reset ao tocar o chão
	if not is_on_floor():
		velocity.y += gravidade * delta
	else:
		velocity.y = 0 
		
	# Prioridade de execução de funções
	if player_na_area and is_instance_valid(player_na_area):
		movimentacao_perseguicao()
	else:
		movimentacao_patrulha()

	move_and_slide()

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
			inverter_direcao()
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
	if body.name == "Carnage":
		player_na_area = body
		
func _on_area_2d_body_exited(body):
	if body == player_na_area:
		player_na_area = null
		# Quando player sai da área, reinicia patrulha
		ponto_inicial = global_position
		
