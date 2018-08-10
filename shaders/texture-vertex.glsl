#version 330 core

layout (location = 0) in vec3 in_position;
layout (location = 1) in vec2 in_uv;

out vec2 uv;

void main()
{
    gl_Position = vec4(in_position, 1);
    uv = in_uv;
}
