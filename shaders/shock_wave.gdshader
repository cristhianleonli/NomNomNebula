shader_type canvas_item;
uniform vec2 center;
uniform float force;
uniform float size ;
uniform float thickness;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x/SCREEN_PIXEL_SIZE.y;
	vec2 sUV = (SCREEN_UV - vec2(0.5, 0.5))/vec2(ratio, 1.0) + vec2(0.5, 0.5);
	float mask = 1.0- smoothstep(size-0.1, size+0.1,length(sUV - center));
	mask *= smoothstep(size-thickness-0.1, size-thickness,length(sUV - center));
	vec2 disp = normalize(sUV - center) * force * mask;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV-disp);
}