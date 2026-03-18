shader_type canvas_item;
render_mode unshaded;

// Resolucion para el efecto pixel-art
uniform vec2 resolution = vec2(64.0, 64.0);
uniform float colorResolution : hint_range(0.0, 100.0, 1.0) = 100.0; // Cantidad de colores por canal

// Centro del vortice (Agujero negro)
uniform float holeSize : hint_range(0.0, 0.5, 0.01) = 0.2;
uniform sampler2D holeColor : source_color; // Usar GradientTexture1D

// Valores del Vortice (Polar)
uniform sampler2D image : repeat_enable, filter_nearest; // Se recomienda Noise
uniform float rotations : hint_range(0.0, 10.0, 0.5) = 1.0; 
uniform float depth : hint_range(0.0, 10.0, 0.1) = 0.5; 
uniform float spiralIntensity : hint_range(-10.0, 10.0, 0.1) = 1.0; 
uniform float shrinkSpeed : hint_range(-10.0, 10.0, 0.1) = 0.2; 
uniform float rotationSpeed : hint_range(-10.0, 10.0, 0.1) = 0.1; 

// Sistema de colores modulares (Como un arcoiris que puedes sumar/restar colores)
// Debes cambiar estos valores por código GDScript (mat.set_shader_parameter(...))
uniform int color_count = 1;
uniform vec4 colors[8] : source_color;

vec2 toPolar(vec2 cartesian){
	float distance_val = length(cartesian);
	float angle = atan(cartesian.y, cartesian.x) + PI;
	return vec2(angle / (2.0 * PI), distance_val);
}

// Interpola suavemente entre los colores activos del array
vec4 get_palette_color(float t) {
	if (color_count <= 0) return vec4(0.0); // Seguro contra posibles errores
	int active_colors = clamp(color_count, 1, 8);
	if (active_colors == 1) return colors[0];
	
	// Envolvemos 't' entre 0.0 y 1.0, y lo escalamos por la cantidad de colores
	float scaled_t = fract(t) * float(active_colors);
	int index = int(scaled_t);
	
	int next_index = index + 1;
	if (next_index >= active_colors) {
		next_index = 0; // Hacemos un loop completo al inicio para cerrarlo como un anillo
	}
	
	float blend = fract(scaled_t);
	return mix(colors[index], colors[next_index], blend);
}

void fragment() {
	vec2 qUV = floor(UV * resolution) / resolution;

	float centerDis = distance(qUV, vec2(0.5, 0.5));
	vec2 offsetUV = vec2(qUV.x - 0.5, qUV.y - 0.5);
	vec2 polarUV = toPolar(offsetUV);
	
	// Aplicar la distorsion del vortice
	polarUV.x *= rotations;
	polarUV.x += polarUV.y * spiralIntensity;
	polarUV.y *= depth;

	// Leer la textura de ruido con el movimiento en el tiempo
	vec4 polarTex = texture(image, vec2(polarUV.x + TIME * rotationSpeed, polarUV.y + TIME * shrinkSpeed));
	
	// Crear el halo usando nuestro sistema modular, usando polarUV.x para que el color gire
	float color_phase = fract(polarUV.x - TIME * rotationSpeed);
	vec4 halo = get_palette_color(color_phase);
	
	// Combinar el color plano con el ruido como en galaxy_distortion
	halo = mix(halo, polarTex * halo, 0.7);
	halo.a *= smoothstep(0.0, 0.5, 0.5 - centerDis); // Desvanecer los bordes
	halo.rgb = ceil(halo.rgb * colorResolution) / colorResolution; // Cuantizar el color

	// Crear el agujero en el centro leyendo el gradiente
	float blackHole = smoothstep(holeSize - 0.05, holeSize, centerDis);
	
	// Map center distance to gradient UV (0.0 at exact center, 1.0 at hole edge)
	float hole_uv = smoothstep(0.0, holeSize, centerDis);
	vec4 hc = texture(holeColor, vec2(hole_uv, 0.5));
	
	vec4 final_color = vec4(0.0);
	final_color.rgb = halo.rgb * 3.0; // Multiplicar para hacerlo mas brillante, tipo emision
	final_color.a = halo.a;

	// Fusionar el color exterior con el gradiente del agujero
	final_color.rgb = mix(final_color.rgb, hc.rgb, 1.0 - blackHole);
	final_color.a = max(final_color.a, 1.0 - blackHole); // El interior siempre es opaco

	COLOR = final_color;
}
