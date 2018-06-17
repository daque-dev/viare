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
import viare.heightmap;

struct Color
{
public:
    uint r, g, b, a;

    this(uint r, uint g, uint b, uint a)
    {
	this.r = r;
	this.g = g;
	this.b = b;
	this.a = a;
    }

    this(uint combined)
    {
	r = combined % 0x100;
	combined >>= 8;
	g = combined % 0x100;
	combined >>= 8; b = combined % 0x100;
	combined >>= 8;
	a = combined % 0x100;
    }

    uint toInt()
    {
	uint color = 0u;
	color += a;
	color <<= 8;
	color += b;
	color <<= 8;
	color += g;
	color <<= 8;
	color += r;
	
	return color;
    }

}

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
    Texture testTexture = new Texture(200, 200);

    // Height Map stuff
    uint[] pixels;
    float[][] heights;
    float highest;
    float lowest;
    uint percent = 0;

    // centers generation
    int noCenters = uniform!"[]"(300, 400);
    QuevCentersGenerator centersGenerator = new StdQuevCentersGenerator();
    QuevCenter[] centers = centersGenerator(noCenters);
    QuevHeightFunction quevFunction = new QuevHeightFunction(centers);
    // end centers generation

    // make heights a width x height matrix
    heights.length = testTexture.width;
    for(int i = 0; i < testTexture.width; i++) 
	    heights[i].length = testTexture.height;

    percent = 0;
    for(uint x = 0; x < testTexture.width; x++)
    for(uint y = 0; y < testTexture.height; y++)
    {
	uint newPercent = (x * testTexture.height + y) * 10 / (testTexture.width *
		testTexture.height);
	if(newPercent != percent)
	{
	    percent = newPercent;
	    writeln(percent * 10, "%");
	}

	heights[x][y] = quevFunction(2.0 * x, 2.0 * y);
    }
    writeln("finished calculating heights");

    highest = heights[0][0];
    lowest = heights[0][0];

    for(uint x = 0; x < testTexture.width; x++)
    for(uint y = 0; y < testTexture.height; y++)
    {
	if(heights[x][y] > highest)
	    highest = heights[x][y];
	if(heights[x][y] < lowest)
	    lowest = heights[x][y];
    }

    pixels.length = testTexture.width * testTexture.height;
    for(int x = 0; x < testTexture.width; x++)
    for(int y = 0; y < testTexture.height; y++)
    {
	float normalizedHeight = (heights[x][y] - lowest) / (highest - lowest);
	if(normalizedHeight > 1.0f) normalizedHeight = 1.0f;
	else if(normalizedHeight < 0.0f) normalizedHeight = 0.0f;

	uint divisions = 30;
	uint division = cast(uint) (round(divisions * normalizedHeight));

	uint componentColor = cast(uint) (cast(float) division / divisions * 0xff);
	float[3] tint = [1.0f, 1.0f, 1.0f];

	float[3] blueTint = [0.0f, 0.6f, 1.0f];
	float[3] greenTint = [0.0f, 0.7f, 0.5f];
	float[3] whiteTint = [1.0f, 1.0f, 1.0f];
	float[3] brownTint = [0.7f, 0.5f, 0.3f];

	if(division < 10)
	    tint[] = blueTint[];
	else
	    tint[] = greenTint[];

	float[3] colors = tint[] * componentColor;
	Color colorStruct = Color(cast(uint) colors[0], cast(uint) colors[1], cast(uint) colors[2], 0xff);
	uint color = colorStruct.toInt();

	pixels[x + y * testTexture.width] = color;
    }

    foreach(QuevCenter center; centers)
    {
	uint x = cast(uint) center.position[0] / 2;
	uint y = cast(uint) center.position[1] / 2;
	pixels[x + y * testTexture.width] = Color(0xff, 0x00, 0x00, 0xff).toInt();
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
		    window.close();
		    break;
		default:
		    break;
	    }
	}
    }
    //

    return;
}
