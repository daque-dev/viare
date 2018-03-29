// Core of the game

import std.stdio;
import std.file;

import derelict.sdl2.sdl;

import viare.abst.world;
import viare.geometry;
import viare.graphics;

void main()
{
    Window window = new Window("viare", 800, 600);
    Shader shader = new Shader(Shader.Type.Vertex, "shaders/test.glsl");
    SDL_Delay(1000);
    return;
}
