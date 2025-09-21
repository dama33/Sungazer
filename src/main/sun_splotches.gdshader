shader_type canvas_item;

uniform float sun_damage[129600];

void fragment() {
	int x_index = int(VERTEX.x / 4.0);
	int y_index = int(VERTEX.y / 4.0);
	float damage_alpha = sun_damage[(y_index * 480) + x_index];
}
