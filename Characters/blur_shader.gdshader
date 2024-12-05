shader_type canvas_item;
uniform float alpha: hint_range(0,1) = 0.5;

void fragment() {
    vec4 col = texture(TEXTURE, UV) * 0.16;
    col += texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE.x, 0.0)) * 0.075;
    col += texture(TEXTURE, UV + vec2(-TEXTURE_PIXEL_SIZE.x, 0.0)) * 0.075;
    col += texture(TEXTURE, UV + vec2(2.0 * TEXTURE_PIXEL_SIZE.x, 0.0)) * 0.06;
    col += texture(TEXTURE, UV + vec2(2.0 * -TEXTURE_PIXEL_SIZE.x, 0.0)) * 0.06;
    col += texture(TEXTURE, UV + vec2(3.0 * TEXTURE_PIXEL_SIZE.x, 0.0)) * 0.045;
    col += texture(TEXTURE, UV + vec2(3.0 * -TEXTURE_PIXEL_SIZE.x, 0.0)) * 0.045;
    col += texture(TEXTURE, UV + vec2(4.0 * TEXTURE_PIXEL_SIZE.x, 0.0)) * 0.025;
    col += texture(TEXTURE, UV + vec2(4.0 * -TEXTURE_PIXEL_SIZE.x, 0.0)) * 0.025;
	col += texture(TEXTURE, UV + vec2(0.0, TEXTURE_PIXEL_SIZE.y)) * 0.075;
    col += texture(TEXTURE, UV + vec2(0.0, -TEXTURE_PIXEL_SIZE.y)) * 0.075;
    col += texture(TEXTURE, UV + vec2(0.0, 2.0 * TEXTURE_PIXEL_SIZE.y)) * 0.06;
    col += texture(TEXTURE, UV + vec2(0.0, 2.0 * -TEXTURE_PIXEL_SIZE.y)) * 0.06;
    col += texture(TEXTURE, UV + vec2(0.0, 3.0 * TEXTURE_PIXEL_SIZE.y)) * 0.045;
    col += texture(TEXTURE, UV + vec2(0.0, 3.0 * -TEXTURE_PIXEL_SIZE.y)) * 0.045;
    col += texture(TEXTURE, UV + vec2(0.0, 4.0 * TEXTURE_PIXEL_SIZE.y)) * 0.025;
    col += texture(TEXTURE, UV + vec2(0.0, 4.0 * -TEXTURE_PIXEL_SIZE.y)) * 0.025;
    COLOR = col;
	COLOR.a = COLOR.a * alpha;
}






