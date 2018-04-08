// Core of the game

import std.stdio;
import std.file;

import derelict.sdl2.sdl;

import viare.abst.world;
import viare.geometry;
import viare.graphics;

template sdl(string typename)
{
    mixin("alias sdl = SDL_" ~ typename ~ ";");
}

void main()
{
    Window window = new Window("viare", 800, 600);

    Shader vertexShader = new Shader(Shader.Type.Vertex, "shaders/vertexdef.glsl");
    Shader fragmentShader = new Shader(Shader.Type.Fragment, "shaders/fragmentdef.glsl");

    Program program = new Program([vertexShader, fragmentShader]);
    program.link();


    Vertex[] vertices = [
	{
	    position: {-0.5, -0.5, 0},
	    color: {1.0, 0.0, 0.0}
	},
	{
	    position: {0.5, -0.5, 0},
	    color: {0.0, 1.0, 0.0}
	},
	{
	    position: {0, 0.5, 0},
	    color: {0.0, 0.0, 1.0}
	}];

    Buffer buffer = new Buffer();
    buffer.bufferData(vertices.ptr, Vertex.sizeof * vertices.length);

    VertexArray!Vertex vertexArray = new VertexArray!Vertex();
    vertexArray.use(buffer);

    window.clear();
    program.use();
    window.render(vertexArray);
    window.print();

    sdl!"Delay"(1000);

    return;
}
