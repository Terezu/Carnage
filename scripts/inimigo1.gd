extends CharacterBody2D

@export var velocidade = 100.0
@export var distancia_patrulha = 200.0

var direcao = 1
var ponto_inicial: Vector2

@onready var sensor_chao = $RayCast2D

func _ready():
	ponto_inicial = global_position
	
func _physics_process(delta):
	# Verificação de gravidade
	if not is_on_floor():
		velocity.y += 980 * delta
	else:
		velocity.y = 0
		
	movimentacao_patrulha()

func movimentacao_patrulha():
	# Define a velocidade horizontal
	velocity.x = direcao * velocidade
	
	# Checa limite da DIREITA (Só vira se estiver indo para a direita)
	if global_position.x > (ponto_inicial.x + distancia_patrulha) and direcao > 0:
		print("Virei por: LIMITE DIREITA")
		inverter_direcao()
		
	# Checa limite da ESQUERDA (Só vira se estiver indo para a esquerda)
	elif global_position.x < (ponto_inicial.x - distancia_patrulha) and direcao < 0:
		inverter_direcao()
		
	# Lógica da detecção de "abismo"
	# Só checamos o abismo se ele estiver no chão, para evitar bugs no ar
	if is_on_floor() and not sensor_chao.is_colliding():
		inverter_direcao()
	
	# 5. Executa o movimento
	move_and_slide()
	
func inverter_direcao():
	direcao *= -1
	sensor_chao.position.x *= -1
	
