shader_type spatial;
render_mode unshaded, fog_disabled, shadows_disabled;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear, repeat_disable;
uniform vec3 color_filter = vec3(1.0, 1.0, 1.0);

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec3 c = textureLod(screen_texture, SCREEN_UV, 1.0).rgb;
	if ((c == color_filter) || ((1.0 - c.x <= 0.15) && (1.0 - c.y <= 0.15) && (1.0 - c.z <= 0.15))) {
		ALBEDO.rgb = color_filter;
	}
	else {
		ALBEDO.rgb = vec3(0.0,0.0,0.0);
	}
}
