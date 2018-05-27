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

void main()
{
    Window window = new Window("viare", 800, 600);

    // GLSL program
    Shader vertexShader = new Shader(Shader.Type.Vertex, "shaders/vertexdef.glsl");
    Shader fragmentShader = new Shader(Shader.Type.Fragment, "shaders/fragmentdef.glsl");
    Program program = new Program([vertexShader, fragmentShader]);
    program.link();

    // Vertex data
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
    GpuArray!Vertex gpuVertices = new GpuArray!Vertex(vertices);


    // Drawing operations
    window.clear();
    program.use();
    window.render(gpuVertices);
    window.print();

    //
    sdl.delay(1000);

    return;
}
