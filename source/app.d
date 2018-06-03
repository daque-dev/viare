// Core of the game

import std.stdio;
import std.file;
import std.ascii;
import std.uni;
import std.string;

import derelict.opengl;
import derelict.sdl2.sdl;
import derelict.sdl2.image;

import viare.abst.world;
import viare.math.geometry;
import viare.graphics;
import viare.sdlize;
import viare.models;

void main()
{
    Window window = new Window("viare", 800, 600);

    // GLSL program
    Program program = new Program([
		new Shader(Shader.Type.Vertex, "shaders/vertexdef.glsl"),
		new Shader(Shader.Type.Fragment, "shaders/fragmentdef.glsl")
	    ]);
    program.link();
    program.setUniform1i("sampler", 0);
    //

    // Model setup
    GpuArray!Vertex square = new GpuArray!Vertex(SQUARE_VERTICES.dup);
    Texture testTexture = new Texture("res/test.png");
    uint[] whiteBlock;
    whiteBlock.length = 100 * 100;
    whiteBlock[0 .. $] = 0xffffffff;
    testTexture.updateRegion(0, 0, 100, 100, whiteBlock);
    //Texture testTexture = new Texture(200, 200);
    // 

    // Drawing operations
    while(window.isOpen())
    {
	window.clear();
	program.use();

	setTextureUnit(0, testTexture);
	window.render(square);

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

    return;
}
