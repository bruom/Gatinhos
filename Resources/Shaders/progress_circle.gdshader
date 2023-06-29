shader_type canvas_item;

uniform vec4 color: source_color;
uniform float upper_bound: hint_range(0.0, 1.0, 0.01);
uniform float lower_bound: hint_range(0.0, 1.0, 0.01);
uniform float donut_inner_radius;

varying vec2 img_pos;

void vertex() {
	img_pos = VERTEX;
}

void fragment() {
	float radius = length(img_pos);
	vec2 ref = normalize(vec2(0.0, -1.0));
	float angle = acos(dot(ref, normalize(img_pos)) / length(ref) * length(normalize(img_pos)));
	float actual_angle = angle;
	if(img_pos.x < 0.0){
		actual_angle = 2.0 * PI - angle;
	}
	
	if(radius < donut_inner_radius) {
		discard;
	}
	
	if(actual_angle > upper_bound * 2.0 * PI){
		discard;
	}
	if(actual_angle < lower_bound * 2.0 * PI){
		discard;
	}
	COLOR.rgb = color.rgb;
}