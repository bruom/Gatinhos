shader_type spatial;
render_mode cull_back;

void vertex() {
	VERTEX.z = VERTEX.z + (0.3 * VERTEX.y * cos(VERTEX.y + TIME));
}

void fragment() {
	ALBEDO = vec3(0.5,0.5,0.5);
}
