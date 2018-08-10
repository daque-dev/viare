#version 330 core

out vec4 FragColor;

in vec2 uv;

uniform sampler2D sampler;

void main()
{
    FragColor = vec4(texture(sampler, uv).rgba);
}
