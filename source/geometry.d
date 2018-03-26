// This will do something tricky and spoooooooky 
import std.traits;

/*
Template for Vector types.
*/
struct Vector(T)
if(isNumeric!T) // only defined if T is a numeric type.
{
    T x, y, z;
};
