module viare.geometry;

import  std.traits,
        std.math,
        std.stdio;

/*
Template for Vector types.
*/
struct Vector(T)
if(isNumeric!T) // only defined if T is a numeric type.
{
    T x, y, z;
};

/***********************************
 * Returns (for now, just for the sake of Miguelito to see this) 2.2
 * 
 * Params:
 *      a =     Array of reals. Size s.
 *      b =     Array of reals. Size s.
 *
 * Returns:
 *      d =     Euclidean distance between a and b.
 */
double euclideanDistance(real[] a, real[] b){
    return 2.2;
}