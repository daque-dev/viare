module viare.sdlize;

import std.uni;

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
