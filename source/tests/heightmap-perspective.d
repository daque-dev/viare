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


void heightmapPerspectiveTest()
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

    perspective.setUniform!(1, "f")(uZn, [0.1]);
    perspective.setUniform!(1, "f")(uZf, [100.0f]);
    perspective.setUniform!(1, "f")(alpha, [45.0f]);
    perspective.setUniform!(1, "f")(xyRatio, [800.0f / 600.0f]);
    perspective.setUniform!(3, "f")(translation, [0.0f, 0.0f, -2.5f]);

	// Height Function 
	immutable numberOfCenters = uniform!"[]"(300, 400);
	QuevCenter[] centers = new StdQuevCentersGenerator()(numberOfCenters);
	HeightFunction heightFunction = new QuevHeightFunction(centers);

	// HeightMap Fill
	HeightMap heightMap = new HeightMap(100, 100);
	writeln("Calculating heights");
	heightMap.fillByHeightFunction(heightFunction);
	writeln("Finished calculating heights");
	heightMap.normalize();

	// Tints
	float[3] blueTint = [0.0f, 0.3f, 0.7];
	float[3] greenTint = [0.0f, 0.7f, 0.5f];
	float[3] whiteTint = [1.0f, 1.0f, 1.0f];
	float[3] brownTint = [0.7f, 0.5f, 0.3f];

	// HeightMap Rendering Configuration
	WaterTerrainHeightMapRenderer renderer = new WaterTerrainHeightMapRenderer();
	renderer.setWaterLevel(0.5);
	renderer.setWaterTint(blueTint);
	renderer.setTerrainTint(brownTint);
	renderer.setDivisions(10);

	glEnable(GL_DEPTH_TEST);
	// Drawing operations
	while (window.isOpen())
	{
		window.clear();
		window.print();

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

	return;
}
