shader_type canvas_item;

uniform float sun_damage[4080];

void fragment() {
	int x_index = int(UV.x * 60.0);
	int y_index = int(UV.y * 67.5);
	float damage_alpha = sun_damage[(y_index * 60) + x_index];
	
	//float damage_alpha = sun_damage[4049];
	
	COLOR = vec4(0, 0, 0, damage_alpha);
}
