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

unittest{
    Vector!int vec_int;
    assert(vec_int.x == 0 && vec_int.y == 0 && vec_int.z == 0);
    vec_int.x = 3;
    vec_int.y = 2;
    vec_int.z = 1;
    assert(vec_int.x == 3 && vec_int.y == 2 && vec_int.z == 1);
}
