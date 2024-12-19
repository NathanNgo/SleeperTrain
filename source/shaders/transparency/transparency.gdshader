shader_type canvas_item;

uniform vec2 interior_bottom_left;
uniform vec2 interior_top_right;
uniform vec2 exterior_bottom_left;
uniform vec2 exterior_top_right;
uniform float intensity;
uniform bool interior_is_transparent = true;

void get_percentage_positions(
	interior_bottom_left,
	interior_top_right,
	exterior_bottom_left,
	exterior_top_right
) {
	
}

void fragment()
{
	float position_x = UV.x;
	float position_y = UV.y;
	bool transparent_location; 
	
	if (interior_is_transparent) {
		// Inside the box
		transparent_location = (position_x > bottom_left.x) && (position_x < top_right.x)
		&& (position_y > bottom_left.y) && (position_y < top_right.y);
	} else {
		// Outside the box
		transparent_location = (position_x < bottom_left.x) || (position_x > top_right.x)
		|| (position_y < bottom_left.y) || (position_y > top_right.y);
	}

	if (transparent_location) {
		COLOR.a = intensity;
	}
}

