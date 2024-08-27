extends RigidBody3D 

@export_range(750.0, 3000.0) var thrust: float = 10000.0
@export var torque: float = 300
var is_transitioning: bool = false
@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var death_audio: AudioStreamPlayer = $DeathAudio
@onready var win_audio: AudioStreamPlayer = $WinAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $CloneParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
var death_count:int

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust) 
		booster_particles.emitting = true
		if rocket_audio.playing == false:
			rocket_audio.play()
	else:
		rocket_audio.stop()
			
	
	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0, 0.0, torque * delta))
		booster_particles.emitting = true
		
	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0, 0.0, -torque * delta))
		booster_particles.emitting = true
		
	if Input.is_action_pressed("down"):
		apply_central_force(-basis.y * delta * thrust) 
		
	
	
func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:
		if "Goal" in body.get_groups():
			complete_level(body.file_path)
		
		if "Death" in body.get_groups():
			crash_sequence()

func crash_sequence() -> void:
	gravity_scale = 5
	print("KABOOM!!")
	explosion_particles.emitting = true 
	explosion_audio.play()
	death_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(get_tree().reload_current_scene)
	print(".",death_count)
	death_count = (death_count + 1)
	print("Death Count: ", death_count)
	
	
func complete_level(next_level_file: String) -> void:
	print("You Win!!!")
	win_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))
	
