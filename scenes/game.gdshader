shader_type canvas_item;

const float TWO_PI = 6.283185307179586;

uniform float grid_size : hint_range(1.0, 100.0) = 15.0;
uniform float tile_speed : hint_range(0.1, 10.0) = 2.0;
uniform vec4 color1 : hint_color = vec4(0.62, 0.14, 0.0, 1.0);
uniform vec4 color2 : hint_color = vec4(0.93, 0.54, 1.0, 1.0);
uniform vec4 color3 : hint_color = vec4(0.36, 0.29, 0.41, 1.0);

vec2 grid(in vec2 uv, in float size) {
    return fract(uv * size);
}

float random (vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec3 getColor(in vec2 coord, in vec2 tile_coord) {
    float tile_mod = mod(tile_coord.x + tile_coord.y, 3.0);

    if (tile_mod == 1.0) {   
        return color1.rgb;
    } else if (tile_mod == 2.0) { 
        return color2.rgb;
    }
	 
    return color3.rgb;
}

void fragment() {
    vec2 res = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 frag = (2.0 * FRAGCOORD.xy - res.xy) / res.y;

    frag = grid(UV, grid_size);
    vec2 tile_coord = floor(UV*grid_size);

    vec3 color = getColor(frag, tile_coord);
    vec2 black = smoothstep(1.08, 0.95, cos(frag * TWO_PI));

    color *= black.x * black.y * smoothstep(1.0, 0.0, length(fract(frag) - 0.5));
    color *= 0.1 + 0.5 * cos(random(floor(UV*grid_size)) * TIME * tile_speed);

    COLOR = vec4(color, 1.0);
}