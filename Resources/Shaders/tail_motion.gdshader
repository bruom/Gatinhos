shader_type spatial;
render_mode cull_back;

uniform sampler2D main_tex;
uniform float motion_speed = 1.0;
uniform float motion_amount = 1.0;

void vertex() {
	if(VERTEX.y < -15.0){
		VERTEX.z = VERTEX.z + 8.0 * motion_amount * cos(TIME * motion_speed + VERTEX.y * 0.05);
	}
}

void fragment() {
	ALBEDO = texture(main_tex, UV).rgb;
}
