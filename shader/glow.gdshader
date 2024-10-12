shader_type canvas_item;
render_mode blend_add;
uniform vec2 rect_size = vec2(.1, .1);
uniform float bness = 1.0;
uniform float fall_off_scale = 3.0;
uniform float b_offset = 0.0; 
void fragment() {
    vec2 uv = UV - vec2(.5);  // Center the UV coordinates
    vec2 cloest_rect_point; 
    cloest_rect_point = uv; 
    cloest_rect_point.x = clamp(uv.x, -rect_size.x, rect_size.x);  
    cloest_rect_point.y = clamp(uv.y, -rect_size.y, rect_size.y);   
    
    // Calculate distance from the closest rectangle point
    vec2 cuv = uv - cloest_rect_point;
    float d2c = length(cuv);

    // Calculate the alpha value based on distance
    float alpha = -log(d2c * fall_off_scale + b_offset) * bness;

    // Clamp alpha to avoid negative values and control transparency
    COLOR.a = clamp(alpha, 0.0, 1.0);
}