//shader_type canvas_item;
//
//uniform float intensity = 0;
//uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
//uniform vec2 r_displacement = vec2(3.0, 0.0);
//uniform vec2 g_displacement = vec2(0.0, 0.0);
//uniform vec2 b_displacement = vec2(-3.0, 0.0);
//
//
//void fragment()
//{
	//float r = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*r_displacement) * intensity, 0.0).r;
	//float g = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*g_displacement) * intensity, 0.0).g;
	//float b = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*b_displacement) * intensity, 0.0).b;
	//
	//COLOR = vec4(r, g, b, 1.0);
//}

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform float aberration_intensity = 0.0;
uniform vec2 r_displacement = vec2(3.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.0);
uniform vec2 b_displacement = vec2(-3.0, 0.0);

uniform float wiggle_intensity : hint_range(0.0,1.0) = 0.0;
uniform float time_scale = 5.0;

void fragment()
{
	vec2 uv = SCREEN_UV;

	float wave = sin((uv.y + TIME * time_scale) * 20.0) * 0.01 * wiggle_intensity;
	uv.x += wave;

	float r = texture(SCREEN_TEXTURE, uv + SCREEN_PIXEL_SIZE * r_displacement * aberration_intensity).r;
	float g = texture(SCREEN_TEXTURE, uv + SCREEN_PIXEL_SIZE * g_displacement * aberration_intensity).g;
	float b = texture(SCREEN_TEXTURE, uv + SCREEN_PIXEL_SIZE * b_displacement * aberration_intensity).b;

	vec3 color = vec3(r, g, b);

	float vignette = smoothstep(0.8, 0.3, distance(uv, vec2(0.5)));
	color *= mix(vec3(1.0), vec3(vignette), wiggle_intensity);

	COLOR = vec4(color, 1.0);
}