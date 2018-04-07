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
    Shader shader = new Shader(Shader.Type.Vertex, "shaders/test.glsl");

    sdl!"Delay"(1000);

    sdl!"Window"* windowptr = sdl!"CreateWindow"("this is a test",
	sdl!"WINDOWPOS_CENTERED", sdl!"WINDOWPOS_CENTERED",
	1000, 300, sdl!"WINDOW_SHOWN");

    writeln("created");

    sdl!"Delay"(1000);

    return;
}
