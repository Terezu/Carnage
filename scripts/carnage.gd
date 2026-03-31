extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# Crescimento de 10% ao colidir com inimigo
const FATOR_CRESCIMENTO = 1.1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Aplica gravidade se não estiver no chão
	if not is_on_floor():
		velocity.y += gravity * delta

	# Lógica do pulo
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
 
	# Movimentação simples
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
# Função responsável pela destruição de inimigo e ativação da função de crescimento
func _on_body_entered(body: Node2D):
	if body.is_in_group("Inimigo1"):
		
		# Destrói inimigo
		body.queue_free()
		
		# Cresce Carnage
		crescer_carnage()
		
# Função responsável pelo crescimento do Carnage
func crescer_carnage():
	scale *= FATOR_CRESCIMENTO
	
