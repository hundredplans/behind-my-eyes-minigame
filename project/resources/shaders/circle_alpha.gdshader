shader_type canvas_item;

instance uniform float progress : hint_range(0.0, 1.0) = 0.0;
void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec2 centered_uv = UV - vec2(0.5);
	float angle = atan(centered_uv.y, centered_uv.x);
	float normalized_angle = (angle + PI) / TAU;
	float mask = step(progress, normalized_angle);
    COLOR = vec4(tex.rgb, tex.a * mask) * COLOR;
}
