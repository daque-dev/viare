// Core of the game
module viare.tests.perspective;

import std.stdio;
import std.file;
import std.ascii;
import std.uni;
import std.string;
import std.math;
import std.random;

import core.thread;

import derelict.opengl;
import derelict.sdl2.sdl;
import derelict.sdl2.image;

import daque.math.geometry;
import daque.math.linear;
import daque.math.quaternion;

import daque.graphics.opengl;
import daque.graphics.color;
import daque.graphics.image;
import daque.graphics.sdl;

import viare.models;

import viare.heightmap.quev;
import viare.heightmap.heightmap;
import viare.heightmap.heightfunction;
import viare.heightmap.renderer;

struct Vertex
{
	float[3] position;
	float[4] color;
	static AttributeFormat[] formats =
	[
		{index: 0, size: 3, type: GL_FLOAT, normalized: GL_FALSE, stride: Vertex.sizeof, pointer: cast(void*)Vertex.position.offsetof},
		{index: 1, size: 4, type: GL_FLOAT, normalized: GL_TRUE,  stride: Vertex.sizeof, pointer: cast(void*)Vertex.color.offsetof}
	];
}

void perspectiveTest()
{
    Window window = new Window("viare perspective test", 800, 600);

    Program perspectiveProgram = new Program();
    Shader vertexShader = new Shader(Shader.Type.Vertex, "shaders/perspective-vertex.glsl");
    Shader fragmentShader = new Shader(Shader.Type.Fragment, "shaders/perspective-fragment.glsl");
    perspectiveProgram.attach(vertexShader);
    perspectiveProgram.attach(fragmentShader);
	 perspectiveProgram.link();

	 int uZn = perspectiveProgram.getUniformLocation("z_near");
	 int uZf = perspectiveProgram.getUniformLocation("z_far");
	 int alpha = perspectiveProgram.getUniformLocation("alpha");
	 int xy_ratio = perspectiveProgram.getUniformLocation("xy_ratio");

	 writeln("uZn location = ", uZn);
	 writeln("zf location = ", uZf);

	 perspectiveProgram.setUniform!(1, "f")(uZn, [1.0f]);
	 perspectiveProgram.setUniform!(1, "f")(uZf, [10.0f]);
	 perspectiveProgram.setUniform!(1, "f")(alpha, [45.0f]);
	 perspectiveProgram.setUniform!(1, "f")(xy_ratio, [800.0f / 600.0f]);

	 float gotZf = 0.0f;
	 perspectiveProgram.getUniform!"f"(uZf, &gotZf);

	 writeln("goZf = ", gotZf);

	 Vertex[] vertices =
	 [
		{position: [0, 0, -1.5], color: [1, 0, 0, 1]},
		{position: [1, 0, -1.5], color: [0, 1, 0, 1]},
		{position: [0, 1, -1.5], color: [0, 0, 1, 1]}
	 ];

	 auto gpuVertices = new GpuArray(vertices, cast(uint) vertices.length, Vertex.formats);

	 auto dr = Quaternion!float.getRotation([1, 1, 1], 0.01);

	 auto rotation = dr;

    while(window.isOpen())
    {
        window.clear();

        perspectiveProgram.use();
		  render(gpuVertices);

        window.print();
        SDL_Event event;
        while(SDL_PollEvent(&event))
        {
            switch(event.type)
            {
                case SDL_QUIT:
                    window.close();
                    break;

                default:
                    break;
            }
        }
    }
}
