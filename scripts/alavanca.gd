extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

var acao_feita = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if Input.is_action_just_pressed("Ação") and acao_feita == false:
			animated_sprite.play("ativar")
			acao_feita = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("parede_alavanca"):
		var parede = area.get_parent()
		
		if parede.has_method("quebrar"):
			parede.quebrar()
			queue_free()
