shader_type canvas_item;

uniform vec2 bottom_left;
uniform vec2 top_right;
uniform float intensity;

void fragment()
{
	float position_x = UV.x;
	float position_y = UV.y;

	if (
		(position_x > bottom_left.x) && (position_x < top_right.x)
		&& (position_y > bottom_left.y) && (position_y < top_right.y)
	) {
		COLOR.a = intensity;
	}
}