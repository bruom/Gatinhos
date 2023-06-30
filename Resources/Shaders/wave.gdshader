shader_type spatial;
render_mode blend_mix, depth_draw_opaque;

uniform float inner_radius: hint_range(0.0, 1.0);
uniform float outer_radius: hint_range(0.0, 1.0);

varying vec3 pos;

const float MAX_DISTANCE = 1.0;

float height(float d) {
	return ((outer_radius - d) * (d - inner_radius)) * 3.0;
}

void vertex() {
	vec3 center = vec3(0);
	float d = distance(VERTEX.xz, center.xz);
	VERTEX.y = sin((height(d) + 0.5) * 40.0) * 0.01;
	pos = VERTEX;
}

void fragment() {
	vec2 center = vec2(0);
	float d = distance(pos.xz, center) * 2.0;
	if (d <= MAX_DISTANCE) {
		ALPHA = pos.y * 5.0;
	} else {
		ALPHA = 0.0;
	}
}
