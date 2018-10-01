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


void Perspective_Test()
{
    // window setup
    Window window = new Window("viare perspective test", 800, 600);

    // perspective program setup
    Program perspective = new Program();
    Shader vertex_shader = new Shader(Shader.Type.Vertex, "shaders/perspective-vertex.glsl");
    Shader fragment_shader = new Shader(Shader.Type.Fragment, "shaders/perspective-fragment.glsl");
    perspective.attach(vertex_shader);
    perspective.attach(fragment_shader);
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

    // Triangle vertices specification
    Vertex[] triangle_vertices = [{
        position: [0, 1, 0], 
        color : [1, 0, 0, 1]
    }, {
        position: [1, -1, 0], 
        color : [0, 1, 0, 1]
    }, {
        position: [-1, -1, 0], 
        color : [0, 0, 1, 1]
    }];
    foreach(ref v; triangle_vertices)
        v.position[] = normalize(v.position[]);
    auto triangle_vertices_in_gpu = new GpuArray(triangle_vertices, cast(uint) triangle_vertices.length, Vertex.formats);
    //

    // Translation 
    float[] model_translation = [0.0f, 0.0f, -2.5f];

    // Rotation stuff
    immutable model_step_rotation = Quaternion!float.getRotation([1, 3, 7], 0.01);
    auto model_rotation = cast(Quaternion!float) model_step_rotation;

    immutable controller_movement = 0.1;
    float[][SDL_Scancode] controller_movements =
    [
        SDL_SCANCODE_W: [0, 0, -controller_movement],
        SDL_SCANCODE_S: [0, 0, +controller_movement],
        SDL_SCANCODE_D: [+controller_movement, 0, 0],
        SDL_SCANCODE_A: [-controller_movement, 0, 0],
        SDL_SCANCODE_E: [0, +controller_movement, 0],
        SDL_SCANCODE_Q: [0, -controller_movement, 0]
    ];
    while (window.isOpen())
    {
        // general processing
        model_rotation = model_rotation * model_step_rotation;

        // keyboard state query
        ubyte* keyboard_state = SDL_GetKeyboardState(null);
        foreach(SDL_Scancode code, float[] movement; controller_movements)
        {
            if(keyboard_state[code])
            {
                model_translation[] += movement[];
            }
        }

        // pre-rendering operations
        perspective.setUniformMatrix(rotation, model_rotation.rotationMatrix());
        perspective.setUniform!(3, "f")(translation, model_translation);

        // rendering
        window.clear();
        perspective.use();
        render(triangle_vertices_in_gpu);
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
