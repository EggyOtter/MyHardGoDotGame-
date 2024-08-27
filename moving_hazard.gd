extends AnimatableBody3D

@export var destination: Vector3
@export var duration: float

func _ready() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
