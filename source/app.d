// Core of the game

import std.stdio;
import std.file;
import std.ascii;
import std.uni;

import derelict.sdl2.sdl;

import viare.abst.world;
import viare.math.geometry;
import viare.graphics;
import viare.sdlize;

alias Vectori = float[3];

void main()
{
    Window window = new Window("viare", 800, 600);

    Shader vertexShader = new Shader(Shader.Type.Vertex, "shaders/vertexdef.glsl");
    Shader fragmentShader = new Shader(Shader.Type.Fragment, "shaders/fragmentdef.glsl");

    Program program = new Program([vertexShader, fragmentShader]);
    program.link();


    Vertex[] vertices = [
	{
	    position: [-0.5, -0.5, 0],
	    color: [1.0, 0.0, 0.0]
	},
	{
	    position: [0.5, -0.5, 0],
	    color: [0.0, 1.0, 0.0]
	},
	{
	    position: [0, 0.5, 0],
	    color: [0.0, 0.0, 1.0]
	}];

    Buffer buffer = new Buffer();
    buffer.bufferData(vertices.ptr, Vertex.sizeof * vertices.length);

    VertexArray vertexArray = new VertexArray();
    vertexArray.use!Vertex(buffer);

    window.clear();
    program.use();
    window.render(vertexArray);
    window.print();

    sdl.delay(1000);

    return;
}
