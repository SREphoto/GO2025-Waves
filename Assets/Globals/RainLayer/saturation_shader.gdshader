shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float desaturation_amount : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    // Get the color from the screen
    vec4 color = texture(screen_texture, SCREEN_UV);

    // Calculate luminance (grayscale value)
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    // Mix between original color and grayscale
    vec3 desaturated = mix(color.rgb, vec3(gray), desaturation_amount);

    // Output the result
    COLOR = vec4(desaturated, color.a);
}