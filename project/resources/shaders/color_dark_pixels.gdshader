shader_type canvas_item;

instance uniform vec3 custom_color: source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (!(COLOR.r > 0.99 && COLOR.g > 0.99 && COLOR.b > 0.99)){
		COLOR.rgb *= custom_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
