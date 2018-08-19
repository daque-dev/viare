// Core of the game
module viare.tests.perspective;

import std.stdio;
import std.file;
import std.ascii;
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
import viare.vertex;


void perspectiveTest()
{
    // window setup
    Window window = new Window("viare perspective test", 800, 600);

    // perspective program setup
    Program perspective = new Program();
    Shader vertexShader = new Shader(Shader.Type.Vertex, "shaders/perspective-vertex.glsl");
    Shader fragmentShader = new Shader(Shader.Type.Fragment, "shaders/perspective-fragment.glsl");
    perspective.attach(vertexShader);
    perspective.attach(fragmentShader);
    perspective.link();

    immutable uZn = perspective.getUniformLocation("z_near");
    immutable uZf = perspective.getUniformLocation("z_far");
    immutable alpha = perspective.getUniformLocation("alpha");
    immutable xyRatio = perspective.getUniformLocation("xy_ratio");
    immutable rotation = perspective.getUniformLocation("rotation");
    immutable translation = perspective.getUniformLocation("translation");

    perspective.setUniform!(1, "f")(uZn, [0.1]);
    perspective.setUniform!(1, "f")(uZf, [100.0f]);
    perspective.setUniform!(1, "f")(alpha, [45.0f]);
    perspective.setUniform!(1, "f")(xyRatio, [800.0f / 600.0f]);
    perspective.setUniform!(3, "f")(translation, [0.0f, 0.0f, -2.5f]);

    // Vertex specification
    Vertex[] vertices = [{
        position: [0, 1, 0], 
        color : [1, 0, 0, 1]
    }, {
        position: [1, -1, 0], 
        color : [0, 1, 0, 1]
    }, {
        position: [-1, -1, 0], 
        color : [0, 0, 1, 1]
    }];
    foreach(ref v; vertices)
        v.position[] = normalize(v.position[]);

    auto gpuVertices = new GpuArray(
        vertices,
        cast(uint) vertices.length,
        Vertex.formats);

    // Translation 
    float[] translationVector = [0.0f, 0.0f, -2.5f];

    // Rotation stuff
    immutable dr = Quaternion!float.getRotation([1, 3, 7], 0.01);
    auto rotationQuaternion = cast(Quaternion!float) dr;

    immutable delta = 0.1;
    auto scancode = SDL_SCANCODE_W;
    float[][SDL_Scancode] movements =
    [
        SDL_SCANCODE_W: [0, 0, -delta],
        SDL_SCANCODE_S: [0, 0, +delta],
        SDL_SCANCODE_D: [+delta, 0, 0],
        SDL_SCANCODE_A: [-delta, 0, 0],
        SDL_SCANCODE_E: [0, +delta, 0],
        SDL_SCANCODE_Q: [0, -delta, 0]
    ];
    while (window.isOpen())
    {
        // general processing
        rotationQuaternion = rotationQuaternion * dr;

        ubyte* key = SDL_GetKeyboardState(null);
        foreach(SDL_Scancode code, float[] movement; movements)
            if(key[code])
                translationVector[] += movement[];

        // pre-rendering operations
        perspective.setUniformMatrix(rotation, rotationQuaternion.rotationMatrix());
        perspective.setUniform!(3, "f")(translation, translationVector);

        // rendering
        window.clear();
        perspective.use();
        render(gpuVertices);
        window.print();

        // event processing
        SDL_Event event;
        while (SDL_PollEvent(&event))
        {
            switch (event.type)
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
