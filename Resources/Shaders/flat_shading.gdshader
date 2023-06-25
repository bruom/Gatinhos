shader_type spatial;
render_mode diffuse_toon, specular_toon, cull_back, depth_draw_always;

uniform vec2 uv_offset;
uniform sampler2D mainTex;
uniform sampler2D alphaTex;

void fragment() {
	ALBEDO = texture(mainTex, UV + uv_offset).rgb;
	ALPHA = texture(alphaTex, UV + uv_offset).r;
}
