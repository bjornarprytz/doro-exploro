shader_type canvas_item;

uniform float fade_start = 0.8;
uniform float fade_range = 0.2;

void fragment() {
    vec2 uv = UV - vec2(0.5); // Centering UV coordinates
    float dist = length(uv) * 2.0; // Get distance from center, scaled
    dist = clamp((dist - fade_start) / fade_range, 0.0, 1.0); // Fade starts at fade_start, fully transparent at fade_start + fade_range

    vec4 tex_color = texture(TEXTURE, UV);
    tex_color.a *= 1.0 - dist; // Reduce alpha based on distance

    COLOR = tex_color;
}
