shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 10.0) = 3.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

void fragment() {
    vec2 pixel_size = blur_amount / vec2(textureSize(screen_texture, 0));
    
    vec4 color = vec4(0.0);
    float total_weight = 0.0;
    
    // 9x9 Gaussian kernel
    for (int x = -4; x <= 4; x++) {
        for (int y = -4; y <= 4; y++) {
            float weight = exp(-float(x*x + y*y) / (2.0 * blur_amount * blur_amount));
            color += texture(screen_texture, SCREEN_UV + vec2(float(x), float(y)) * pixel_size) * weight;
            total_weight += weight;
        }
    }
    
    COLOR = color / total_weight;
}