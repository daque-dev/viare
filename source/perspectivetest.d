// Core of the game
module viare.perspectivetest;

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

import viare.graphics.opengl;
import viare.graphics.color;
import viare.graphics.image;

import viare.models;

import viare.heightmap.quev;
import viare.heightmap.heightmap;
import viare.heightmap.heightfunction;
import viare.heightmap.renderer;

import viare.heightmaptest;

void perspectiveTest()
{
    Window window = new Window("viare perspective test", 800, 600);

    Program perspectiveProgram = new Program();
    Shader vertexShader = new Shader(Shader.Type.Vertex, "shaders/perspective-vertex.glsl");
    Shader fragmentShader = new Shader(Shader.Type.Fragment, "shaders/perspective-fragment.glsl");
    
    perspectiveProgram.attach(vertexShader);
    perspectiveProgram.attach(fragmentShader);

    while(window.isOpen())
    {
        window.clear();

        perspectiveProgram.use();

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
