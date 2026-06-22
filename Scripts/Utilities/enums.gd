extends Node

enum GunType{
	PISTOL,
	RIFLE,
	SHOTGUN,
	SNIPER
}

enum FireMode{
	SEMI_AUTOMATIC,
	AUTOMATIC,
	BURST
}

enum PlayerGroundState{
	ON_GROUND,
	IN_AIR,
}

enum PlayerMovementState{
	IDLE,
	WALKING,
	SPRINTING,
	CROUCHING,
	SLIDING,
}