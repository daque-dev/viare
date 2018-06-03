#version 330 core

layout (location = 0) in vec3 inVertexPos;
layout (location = 1) in vec2 inUv;

out vec2 uv;

void main()
{
    gl_Position = vec4(inVertexPos, 1);
    uv = inUv;
}
