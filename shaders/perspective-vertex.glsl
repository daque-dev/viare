#version 330 core

layout (location = 0) in vec3 in_position;
layout (location = 1) in vec4 in_color;

uniform float z_near;
uniform float z_far;
uniform float alpha;
uniform float xy_ratio;
uniform mat3 rotation;

out vec4 v_color;

void main()
{
	mat4 perspective = mat4(
	1 / tan(alpha), 0, 0, 0,
	0, xy_ratio / tan(alpha), 0, 0,
	0, 0, (z_far + z_near)/(z_far - z_near), -1,
	0, 0, 2 * z_far * z_near/(z_far - z_near), 0);

	gl_Position = perspective * vec4(in_position, 1);

	v_color = in_color;
}
