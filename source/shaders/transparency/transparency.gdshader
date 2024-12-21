shader_type canvas_item;

const float half = 0.5;

uniform float width_interior;
uniform float height_interior;
uniform float width_exterior;
uniform float height_exterior;
uniform vec2 origin_interior = vec2(0.0, 0.0);
uniform vec2 origin_exterior = vec2(0.0, 0.0);
uniform float intensity;
uniform bool interior_is_transparent = true;

void fragment() {
	float origin_offset_x = origin_interior.x - origin_exterior.x;
	float origin_offset_y = origin_interior.y - origin_exterior.y;

	float right = (
		(half*(width_interior + width_exterior) + origin_offset_x)/(width_exterior)
	);
	float left = (
		(half*(width_exterior - width_interior) + origin_offset_x)/(width_exterior)
	);
	float top = (
		(half*(height_interior + height_exterior) + origin_offset_y)/(height_exterior)
	);
	float bottom = (
		(half*(height_exterior - height_interior) + origin_offset_y)/(height_exterior)
	);

	float position_x = UV.x;
	float position_y = UV.y;
	bool transparent_location; 
	
	if (interior_is_transparent) {
		transparent_location = (left < position_x) && (position_x < right)
		&& (bottom < position_y) && (position_y < top);
	} else {
		transparent_location = (position_x < left) || (position_x > right)
		|| (position_y < bottom) || (position_y > top);
	}

	if (transparent_location) {
		COLOR.a = intensity;
	}
}

