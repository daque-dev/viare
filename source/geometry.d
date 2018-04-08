module viare.geometry;

import std.traits;
import std.math;
import std.stdio;

/*
Template for Vector types.
*/
struct Vector(T)
if(isNumeric!T) // only defined if T is a numeric type.
{
    T x, y, z;
};