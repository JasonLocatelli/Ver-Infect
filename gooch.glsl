extern vec3 light_vec;
extern vec3 lightColor;
extern vec3 darkColor;
extern float intensityMin;
extern float intensityMax;
extern Image diffuse;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
   vec3 light_direction = light_vec - vec3(pixel_coords, 0);
   float distance = length(light_direction);
   light_direction = normalize(light_direction);

   vec3 normal = Texel(texture, texture_coords).xyz;
   normal.y = 1 - normal.y;
   normal = normalize(mix(vec3(-1), vec3(1), normal));

   float diffuse_term = clamp(dot(normal, light_direction), intensityMin, intensityMax);

   vec3 dark_color = darkColor;
   //vec3 light_color = vec3(0.6, 0.6, 0.0);
   vec3 light_color = lightColor;
   vec3 ambient = mix(dark_color, light_color, diffuse_term) * 0.1;

   // the shaded cel has a light value of 0.5, the light cel has a light value of 1
   float cel_diffuse_term = mix(0, 1, diffuse_term)/2 + 0.7;
   //float cel_diffuse_term = step(0.5, diffuse_term)/2 + 0.5;

   return vec4((cel_diffuse_term * Texel(diffuse, texture_coords).rgb) + ambient, Texel(texture, texture_coords).a);
   //return vec4(ambient+Texel(diffuse, texture_coords).rgb/100, Texel(texture, texture_coords).a);
}