shader_type canvas_item;

uniform vec2 light_pos = vec2(0.3, -0.4); // Light direction (tweak this)
uniform float light_intensity = 1.2; // Light brightness
uniform float ambient_light = 0.3; // Ambient light factor

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // Normalize UVs to range [-1, 1]
    
    float r = length(uv); // Get the radial distance from center
    if (r > 1.0) discard; // Cut out pixels outside the sphere
    
    float z = sqrt(1.0 - r * r); // Spherical projection depth factor
    vec2 sphere_uv = uv * 0.5 + 0.5; // Convert back to texture space

    // Sample texture
    vec4 tex_color = texture(TEXTURE, sphere_uv);

    // Compute lighting
    vec3 normal = normalize(vec3(uv, z)); // Sphere normal
    float diff = max(dot(normal, normalize(vec3(light_pos, 1.0))), 0.0); // Diffuse light
    float light = ambient_light + diff * light_intensity;

    // Apply lighting
    COLOR = tex_color - light;
}