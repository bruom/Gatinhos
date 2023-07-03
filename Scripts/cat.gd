class_name Cat extends CollisionShape3D

signal footstep_occured

@export var body_texture_override: Texture
@export var face_texture_override: Texture
@export var face_alpha_override: Texture
@export var tail_texture_override: Texture

@onready var anim_player = $cat/AnimationPlayer
@onready var cat_body = $cat/Armature001/Skeleton3D/cat01_base001
@onready var cat_tail = $'cat/Armature001/Skeleton3D/cat_tail001'
@onready var facing_object = $cat/Armature001/Skeleton3D/BoneAttachment3D/facing_object

var facing_direction: Vector3:
	get:
		return (facing_object.global_position - global_position).normalized()

var facing_angle_offset: float:
	get:
		var invert = to_local(facing_object.global_position).x > 0.0
		var angle = to_local(facing_object.global_position).angle_to(Vector3.FORWARD)
		return -angle if invert else angle

func _ready():
	if body_texture_override != null:
		var body_mat: ShaderMaterial = cat_body.get_surface_override_material(1)
		body_mat.set_shader_parameter("main_tex", body_texture_override)
	if face_texture_override != null:
		var face_mat: ShaderMaterial = cat_body.get_surface_override_material(0)
		face_mat.set_shader_parameter("main_tex", face_texture_override)
	if face_alpha_override != null:
		var face_mat: ShaderMaterial = cat_body.get_surface_override_material(0)
		face_mat.set_shader_parameter("alpha_tex", face_alpha_override)
	if tail_texture_override != null:
		var face_mat: ShaderMaterial = cat_tail.get_surface_override_material(0)
		face_mat.set_shader_parameter("main_tex", tail_texture_override)

func set_tail_motion_parameters(motion_speed: float, motion_amount: float):
	var shader_mat: ShaderMaterial = cat_tail.get_surface_override_material(0)
	shader_mat.set_shader_parameter("motion_speed", motion_speed)
	shader_mat.set_shader_parameter("motion_amount", motion_amount)

func set_face_uv_offset(uv_offset: Vector2):
	var shader_mat: ShaderMaterial = cat_body.get_surface_override_material(0)
	shader_mat.set_shader_parameter("uv_offset", uv_offset)

func emit_footstep():
	footstep_occured.emit()
