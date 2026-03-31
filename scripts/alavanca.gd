extends CollisionShape2D

@export var Parede_quebrável: Node2D

func _on_body_entered(body: Node2D):
	if body.is_in_group("Carnage"):
		destruir_parede()
		
func destruir_parede():
	if is_instance_valid(Parede_quebrável):
		Parede_quebrável.queue_free()
		
	queue_free()
	
