shader_type canvas_item;

uniform sampler2D mask_texture : filter_nearest;

void fragment() {

    vec4 color = texture(TEXTURE, UV);

    // Use screen-space UVs instead
    vec2 mask_uv = SCREEN_UV;

    float mask = texture(mask_texture, mask_uv).r;

    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    color.rgb = mix(color.rgb, vec3(gray), mask);

    COLOR = color;
}