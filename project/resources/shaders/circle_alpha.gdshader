shader_type canvas_item;

instance uniform float progress : hint_range(0.0, 1.0) = 0.0;
instance uniform int segments : hint_range(4, 64) = 12;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec2 centered_uv = UV - vec2(0.5);
	float angle = atan(centered_uv.y, centered_uv.x);
	float normalized_angle = (angle + PI) / TAU;
	
	// Quantize to discrete segments for pixelated look
	float quantized_angle = floor(normalized_angle * float(segments)) / float(segments);
	
	float mask = step(progress, quantized_angle);
	COLOR = vec4(tex.rgb, tex.a * mask) * COLOR;
}