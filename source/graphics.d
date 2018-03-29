module viare.graphics;

import std.stdio;
import std.string;

import derelict.opengl;
import derelict.sdl2.sdl;

static this()
{
    DerelictSDL2.load();
    DerelictGL3.load();

    if(SDL_Init(SDL_INIT_EVERYTHING) < 0)
    {
	writeln("sdl init failed: ", fromStringz(SDL_GetError()));
    }
}

static ~this()
{
}

class Window
{
    public:
	this(string name, uint width, uint height)
	{
	    m_window = SDL_CreateWindow(name.toStringz(),
		SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
		width, height,
		SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL);
	}
	~this()
	{
	    SDL_DestroyWindow(m_window);
	}

    private:
	SDL_Window* m_window;
};


