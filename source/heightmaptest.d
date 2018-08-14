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

void heightMapDebugging()
{
	immutable noCenters = uniform!"[]"(100, 200);
	QuevCenter[] centers = new StdQuevCentersGenerator()(noCenters);
	HeightFunction heightFunction = new QuevHeightFunction(centers);

	double first = heightFunction(0, 0);
	double second = heightFunction(0.4, 0.4);

	writeln(first);
	writeln(second);
}

/*
deprecated void heightMapTest()
{
	Window window = new Window("viare", 800, 800);

	// GLSL textureProgram
	Program textureProgram = new Program([new Shader(Shader.Type.Vertex, "shaders/texture-vertex.glsl"),
			new Shader(Shader.Type.Fragment, "shaders/texture-fragment.glsl")]);
	textureProgram.link();

	// Model setup
	Vertex[] squareData = SQUARE_VERTICES.dup;
	Vertex[] frontSquareData;
	frontSquareData.length = squareData.length;
	frontSquareData[] = squareData[];
	import std.algorithm;
	frontSquareData.each!((ref v) => v.position[2] += 0.5);

	auto square = new GpuArray!Vertex(SQUARE_VERTICES.dup);
	auto frontSquare = new GpuArray!Vertex(frontSquareData);

	// Texture creation
	Texture testTexture = new Texture(100, 100);
	Texture frontTexture = new Texture(100, 100);

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
	renderer.setDivisions(10);

	// HeightMap rendering
	writeln("Rendering");
	Image image = renderer.render(heightMap);
	testTexture.updateRegion(0, 0, testTexture.width, testTexture.height,
			image.linearize!(MatrixOrder.RowMajor)());
	writeln("Finished rendering");


	setTextureUnit(0, testTexture);
	setTextureUnit(1, frontTexture);

	glEnable(GL_DEPTH_TEST);
	// Drawing operations
	while (window.isOpen())
	{
		window.clear();

		textureProgram.use();

		textureProgram.setUniform1i("sampler", 0);
		render(square);
		
		textureProgram.setUniform1i("sampler", 1);
		render(frontSquare);

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
*/
