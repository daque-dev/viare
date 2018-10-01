module viare.tests.heightmapperspective;

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

import daque.math.linear;
import daque.math.geometry;
import daque.math.quaternion;

import daque.graphics.opengl;
import daque.graphics.sdl;
import daque.graphics.color;
import daque.graphics.image;

import viare.models;

import viare.heightmap.quev;
import viare.heightmap.heightmap;
import viare.heightmap.heightfunction;
import viare.heightmap.renderer;

import viare.vertex;


void Heightmap_Perspective_Test()
{
	Window window = new Window("viare", 800, 800);

	// GLSL textureProgram
	Program perspective = new Program([
            new Shader(Shader.Type.Vertex, "shaders/perspective-vertex.glsl"),
			new Shader(Shader.Type.Fragment, "shaders/perspective-fragment.glsl")]);
	perspective.link();

    // Uniform setting
    immutable uZn = perspective.getUniformLocation("z_near");
    immutable uZf = perspective.getUniformLocation("z_far");
    immutable alpha = perspective.getUniformLocation("alpha");
    immutable xyRatio = perspective.getUniformLocation("xy_ratio");
    immutable rotation = perspective.getUniformLocation("rotation");
    immutable translation = perspective.getUniformLocation("translation");

    perspective.setUniform!(1, "f")(uZn, [1.0f]);
    perspective.setUniform!(1, "f")(uZf, [100.0f]);
    perspective.setUniform!(1, "f")(alpha, [45.0f]);
    perspective.setUniform!(1, "f")(xyRatio, [800.0f / 600.0f]);
    perspective.setUniform!(3, "f")(translation, [0.0f, 0.0f, -2.5f]);

	// Height Function 
	immutable number_of_centers = uniform!"[]"(300, 400);
	QuevCenter[] centers = new StdQuevCentersGenerator()(number_of_centers);
	HeightFunction height_function = new QuevHeightFunction(centers);

	// Heightmap Fill
	Heightmap heightmap = new Heightmap(70, 70);
	writeln("Calculating heights");
	heightmap.Fill_By_Height_Function(height_function);
	writeln("Finished calculating heights");
	heightmap.Normalize();
    //

	// Tints
	float[3] blue_tint = [0.0f, 0.3f, 0.7];
	float[3] green_tint = [0.0f, 0.7f, 0.5f];
	float[3] white_tint = [1.0f, 1.0f, 1.0f];
	float[3] brown_tint = [0.7f, 0.5f, 0.3f]; 
    //

	// Heightmap Rendering 
	WaterTerrainHeightmapRenderSettings heightmap_render_settings = {water_level: 0.5, water_tint: blue_tint, terrain_tint: brown_tint, divisions: 20};
    Vertex[] heightmap_mesh = Get_Heightmap_Mesh(heightmap_render_settings, 5.0f, [20.0f, 20.0f], heightmap);
    GpuArray heightmap_mesh_in_gpu = new GpuArray(heightmap_mesh, cast(uint) heightmap_mesh.length, Vertex.formats);
    //

    // Depth mask OpenGL configuration
	glEnable(GL_DEPTH_TEST);
    glDepthMask(GL_TRUE);
    glDepthFunc(GL_GREATER);
    glClearDepth(0.0);
    //
	
    // Model translation 
    float[] model_translation = [0.0f, 0.0f, -2.5f];
    //

    // Model rotation
    immutable model_step_rotation = Quaternion!float.getRotation([0, 1, 0], 0.01);
    auto model_rotation = cast(Quaternion!float) model_step_rotation;
    //

    // Controller configuration
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
    //

	while (window.isOpen())
	{
        // keyboard state querying
        ubyte* keyboard_state = SDL_GetKeyboardState(null);
        //

        // controller action taking
        foreach(SDL_Scancode controller_key_scancode, float[] controller_movement; controller_movements)
        {
            if (keyboard_state[controller_key_scancode])
            {
                model_translation[] += controller_movement[];
            }
        }
        //

        // step rotation
        model_rotation = model_rotation * model_step_rotation;
        //

        // uniform setting
        perspective.setUniformMatrix(rotation, model_rotation.rotationMatrix());
        perspective.setUniform!(3, "f")(translation, model_translation);
        //

        // rendering
		window.clear();
        perspective.use();
        render(heightmap_mesh_in_gpu);
		window.print();
        //

        // event handling
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
        //
	}

	return;
}
