module viare.sdlize;

import std.uni;

import derelict.sdl2.sdl;

pure string sdlize(in string inString)
{
    return toUpper(inString[0 .. 1]) ~ inString[1 .. $];
}

struct sdl
{
    template opDispatch(string str)
    {
	mixin("alias opDispatch = SDL_" ~ sdlize(str) ~ ";");
    }
}

struct sdlgl
{
    template opDispatch(string str)
    {
	alias opDispatch = sdl.opDispatch!("GL_" ~ sdlize(str));
    }
}
