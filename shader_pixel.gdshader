shader_type canvas_item;

uniform sampler2D screen: hint_screen_texture ,filter_nearest;
uniform int cell_size = 1;


void fragment(){
	if (cell_size == 1)
	{
		discard;
	}
	vec2 num_cells = vec2(textureSize(screen,0))/float(cell_size);

	vec2 new_uv = floor(SCREEN_UV*num_cells)/num_cells;
	vec4 output_color = texture(screen,new_uv);

	float alpha = (16.0-float(cell_size))/16.0;

	COLOR = output_color * vec4(alpha,alpha,alpha,1.0);
}