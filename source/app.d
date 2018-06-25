// Core of the game

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

import viare.abst.world;

import viare.math.geometry;

import viare.graphics;

import viare.models;

import viare.heightmap.quev;
import viare.heightmap.heightmap;
import viare.heightmap.heightfunction;

void main()
{
    Window window = new Window("viare", 800, 800);

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
    Texture testTexture = new Texture(400, 400);

    int numberOfCenters = uniform!"[]"(300, 400);
    QuevCenter[] centers = new StdQuevCentersGenerator()(numberOfCenters);
    HeightFunction heightFunction = new QuevHeightFunction(centers);

    HeightMap heightMap = new HeightMap(testTexture.width, testTexture.height);
    heightMap.fillWithHeightFunction(heightFunction);
    heightMap.normalize();

    float[3] blueTint = [0.0f, 0.3, 0.5f];
    float[3] greenTint = [0.0f, 0.7f, 0.5f];
    float[3] whiteTint = [1.0f, 1.0f, 1.0f];
    float[3] brownTint = [0.7f, 0.5f, 0.3f];

    Pixel2D image = new Pixel2D(testTexture.width, testTexture.height);
    HeightMapRenderer heightMapRenderer = new WaterTerrainHeightMapRenderer();
    heightMapRenderer.setNumberOfDivisions(50);
    heightMapRenderer.setWaterLevel(0.5);
    heightMapRenderer.setWaterTint(blueTint);
    heightMapRenderer.setTerrainTint(greenTint);
    heightMapRenderer.renderOn(image);

    for(int x = 0; x < testTexture.width; x++)
    for(int y = 0; y < testTexture.height; y++)
    {
	uint divisions = 50;
	uint division = cast(uint) (round(divisions * normalizedHeight));
	double waterLevel = 0.5;

	uint componentColor = cast(uint) (cast(float) division / divisions * 0xff);
	float[3] tint = [1.0f, 1.0f, 1.0f];

	float[3] blueTint = [0.0f, 0.3, 0.5f];
	float[3] greenTint = [0.0f, 0.7f, 0.5f];
	float[3] whiteTint = [1.0f, 1.0f, 1.0f];
	float[3] brownTint = [0.7f, 0.5f, 0.3f];

	if(division < divisions * waterLevel)
	    tint[] = blueTint[];
	else
	    tint[] = greenTint[];

	float[3] colors = tint[] * componentColor;
	Color colorStruct 
	    = Color(cast(uint) colors[0], 
		    cast(uint) colors[1], 
		    cast(uint) colors[2], 0xff);
	uint color = colorStruct.toInt();

	pixels[x + y * testTexture.width] = color;
    }

    foreach(QuevCenter center; centers)
    {
	double x = center.position[0] * testTexture.width;
	double y = center.position[1] * testTexture.height;

	uint ux = cast(uint) x;
	uint uy = cast(uint) y;
	pixels[ux + uy * testTexture.width] = Color(0xff, 0, 0, 0xff).toInt();
    }
    testTexture.updateRegion(0, 0, testTexture.width, testTexture.height, pixels);
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
		    window.close(); break; default:
		    break;
	    }
	}
    }
    //

    return;
}
