shader_type canvas_item;
render_mode unshaded;

uniform vec2 resolution = vec2(64, 64);
uniform float colorResolution : hint_range(0.0, 100.0, 1.0) = 100.0; //Amount of colors per channel

//Hole Uniforms
uniform float holeSize : hint_range(0.0, 0.5, 0.01) = 0.2;
uniform sampler2D holeColor; //Use a gradient

//Polor Uniforms
uniform sampler2D image : repeat_enable, filter_nearest; //Noise Recommended
uniform float rotations : hint_range(0.0, 10.0, 0.5) = 1.0; //Number of times the texture loops around the circle
uniform float depth : hint_range(0.0, 10.0, 0.1) = 0.5; //Number of times the texture loops from the center to the outside of the circle
uniform float spiralIntensity : hint_range(-10.0, 10.0, 0.1) = 1.0; // The amount the texture rotates as it moves towards the center
uniform float shrinkSpeed : hint_range(-10.0, 10.0, 0.1) = 0.2; //Speed at which the texture moves towards the center
uniform float roationSpeed : hint_range(-10.0, 10.0, 0.1) = 0.1; //Speed at which the texture roates around the center
uniform sampler2D haloColor; //Color of the spiral, use a gradient

vec2 toPolar(vec2 cartesian){
	float distance = length(cartesian);
	float angle = atan(cartesian.y, cartesian.x) + PI;
	return vec2(angle / (2.0 * PI), distance);
}

void fragment() {
	vec2 qUV = floor(UV * resolution) / resolution;

	float centerDis = distance(qUV, vec2(0.5, 0.5));
	vec2 offsetUV = vec2(qUV.x - 0.5, qUV.y - 0.5);
	vec2 polarUV = toPolar(offsetUV);
	polarUV.x *= rotations;
	polarUV.x += polarUV.y * spiralIntensity;
	polarUV.y *= depth;

	//Polar Texture
	vec4 polarTex = texture(image, vec2(polarUV.x + TIME * roationSpeed, polarUV.y + TIME * shrinkSpeed));
	vec4 halo = texture(haloColor, vec2(smoothstep(0.7, 1.0, 1.0 - length(offsetUV)), offsetUV.y));
	halo = mix(halo, polarTex * halo, 0.7);
	halo.a *= smoothstep(0.0, 0.5, 0.5 - centerDis);
	halo.rgb = ceil(halo.rgb * colorResolution) / colorResolution;

	//Black Hole
	float blackHole = smoothstep(holeSize - 0.05, holeSize, centerDis);
	vec4 hc = texture(holeColor, vec2(smoothstep(0.0, holeSize, centerDis)));

	// Combine: halo visible area + black hole center
	vec4 c = vec4(0.0); // Start fully transparent
	c.rgb = halo.rgb * 3.0;
	c.a = halo.a;

	// Mix in black hole color at the center
	c.rgb = mix(c.rgb, hc.rgb, 1.0 - blackHole);
	c.a = max(c.a, 1.0 - blackHole); // Black hole center is fully opaque

	COLOR = c;
}