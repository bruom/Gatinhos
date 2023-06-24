shader_type spatial;

global uniform vec3 player_position;

varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
}

void fragment() {
	vec3 player_screen_pos = (MODEL_MATRIX * (vec4(player_position, 1.0) * MODEL_MATRIX)).xyz;
	if(distance(VERTEX, player_screen_pos) < 5.0) {
		discard;
	}
}
