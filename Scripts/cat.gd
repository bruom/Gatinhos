class_name Cat extends CollisionShape3D

@onready var anim_player = $cat/AnimationPlayer
@onready var cat_body = $cat/Armature001/Skeleton3D/cat01_base001
@onready var cat_tail = $'cat/Armature001/Skeleton3D/cat_tail001'

func set_tail_motion_parameters(motion_speed: float, motion_amount: float):
	var shader_mat: ShaderMaterial = cat_tail.get_surface_override_material(0)
	shader_mat.set_shader_parameter("motion_speed", motion_speed)
	shader_mat.set_shader_parameter("motion_amount", motion_amount)

func set_face_uv_offset(uv_offset: Vector2):
	var shader_mat: ShaderMaterial = cat_body.get_surface_override_material(0)
	shader_mat.set_shader_parameter("uv_offset", uv_offset)
