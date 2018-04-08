#version 330 core
layout (location = 0) in vec3 inVertexPos;
layout (location = 1) in vec3 inVertexColor;

out vec4 vertexColor;

void main()
{
    gl_Position = vec4(inVertexPos, 1);
    vertexColor = vec4(inVertexColor, 1);
}
