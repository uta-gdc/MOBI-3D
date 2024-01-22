shader_type canvas_item;


uniform vec4 original_0: source_color;
uniform vec4 original_1: source_color;
uniform vec4 replace_0: source_color;
uniform vec4 replace_1: source_color;

const float precision = 0.3;


vec4 swap_color(vec4 color){
	vec4 original_colors[2] = vec4[2] (original_0, original_1);
	vec4 replace_colors[2] = vec4[2] (replace_0, replace_1);
	for (int i = 0; i < 2; i ++) {
		if (distance(color, original_colors[i]) <= precision){
			return replace_colors[i];
		}
	}
	return color;
}


void fragment() {
	COLOR = swap_color(texture(TEXTURE, UV));
}