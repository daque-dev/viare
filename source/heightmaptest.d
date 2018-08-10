// Core of the game
module viare.heightmaptest;

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

import viare.math.geometry;
import viare.math.types;

import viare.graphics.opengl;
import viare.graphics.color;
import viare.graphics.image;

import viare.models;

import viare.heightmap.quev;
import viare.heightmap.heightmap;
import viare.heightmap.heightfunction;
import viare.heightmap.renderer;

void heightMapTest()
{
	Window window = new Window("viare", 800, 800);

	// GLSL textureProgram
	Program textureProgram = new Program([new Shader(Shader.Type.Vertex, "shaders/texture-vertex.glsl"),
			new Shader(Shader.Type.Fragment, "shaders/texture-fragment.glsl")]);
	textureProgram.link();

	// Model setup
	GpuArray!Vertex square = new GpuArray!Vertex(SQUARE_VERTICES.dup);

	// Texture creation
	Texture testTexture = new Texture(100, 100);

	// Height Function 
	immutable numberOfCenters = uniform!"[]"(300, 400);
	QuevCenter[] centers = new StdQuevCentersGenerator()(numberOfCenters);
	HeightFunction heightFunction = new QuevHeightFunction(centers);

	// HeightMap Fill
	HeightMap heightMap = new HeightMap(testTexture.width, testTexture.height);
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

	// HeightMap rendering
	writeln("Rendering");
	Image image = renderer.render(heightMap);
	testTexture.updateRegion(0, 0, testTexture.width, testTexture.height,
			image.linearize!(MatrixOrder.RowMajor)());
	writeln("Finished rendering");

	textureProgram.setUniform1i("sampler", 0);

	// Drawing operations
	while (window.isOpen())
	{
		window.clear();

		textureProgram.use();
		setTextureUnit(0, testTexture);
		window.render(square);

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
