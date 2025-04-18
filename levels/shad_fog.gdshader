shader_type canvas_item;

uniform vec2 tiling = vec2(2.0, 1.0);
uniform vec2 offset = vec2(0.0, 0.0);
uniform bool moving = false;
void vertex() {
    UV *= tiling;
    UV += offset;

    if (moving) {
        UV += offset * TIME;
    }
}

void fragment() {
	vec2 newUV = fract(UV);
	COLOR = texture(TEXTURE, newUV);
}