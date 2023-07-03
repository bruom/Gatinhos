shader_type spatial;
render_mode diffuse_toon, specular_toon, cull_back, depth_draw_always;

uniform vec2 uv_offset;
uniform sampler2D main_tex;
uniform sampler2D alpha_tex;

void fragment() {
	ALBEDO = texture(main_tex, UV + uv_offset).rgb;
	ALPHA = texture(alpha_tex, UV + uv_offset).r;
}
