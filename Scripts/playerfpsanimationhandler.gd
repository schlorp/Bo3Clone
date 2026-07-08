extends Node
class_name PlayerFPSAnimationHandler

@export var arms_animation_player: AnimationPlayer = null
@export var gun_animation_player: AnimationPlayer = null

func play_joint_animation(animation_name: String) -> void:
	match animation_name:
		"idle":
			arms_animation_player.play("arm_animations/FP_idle")
			gun_animation_player.play("gun_animations/QBZ_idle")
		"fire":
			arms_animation_player.play("arm_animations/FP_fire")
			gun_animation_player.play("gun_animations/QBZ_fire")
		"reload":
			arms_animation_player.play("arm_animations/FP_reload")
			gun_animation_player.play("gun_animations/QBZ_reload")
