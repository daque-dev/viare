module viare.geometry;

import std.traits;
import std.math;
import std.algorithm;
import std.algorithm.comparison;
import std.functional;
import std.array;
import std.stdio;
import std.conv;
import std.range;

alias Vector = float[3];

pure float sigma(alias F)(int n, int N)
if(isFunction!F && functionAttributes!F & FunctionAttribute.pure_)
{
    float r = 0;
    for(int i = n; i < N; i++)
	r += F(i);
    return r;
}

pure float magnitude(Vector v)
{
    return pipe!(array,
        map!(a => cast(float)(a)),
        map!(a => a * a),
        sum, sqrt)(v);
}

pure Vector normalize(Vector v)
{
    Vector normalized =  v[] / magnitude (v);
    return normalized;
}

unittest
{
    // Consider floating point *inexistent* accuracy problems.
    enum tolerance = 1e-12;

    // Inputs to be tested
    Vector[] vectors = [
        [3, 1, 2],
        [-3, -1, -2],
        [1, 1, 1],
        [0, 0, 0]
    ];

    // Magnitude
    auto magnitudes = map!magnitude(vectors);
    assert(magnitudes.array[] == [sqrt(14.0f), sqrt(14.0f), sqrt(3.0f), 0.0f]);
    assert(magnitudes[0] == sqrt(14.0f));
    assert(magnitudes[1] == sqrt(14.0f));
    assert(magnitudes[2] == sqrt(3.0f));
    assert(magnitudes[3] == 0.0f);
   
    // Normalization
    auto normalizedVectors = map!normalize(vectors);

    Vector dv0 = normalizedVectors[0][] - [3.0f/sqrt(14.0f), 1.0f/sqrt(14.0f), 2.0f/sqrt(14.0f)];
    assert(dv0[] == [0, 0, 0], "normalizedVectors[0] delta not equal to 0 vector");

    Vector dv1 = normalizedVectors[1][] + [3.0f/sqrt(14.0f), 1.0f/sqrt(14.0f), 2.0f/sqrt(14.0f)];
    assert(dv1[] == [0, 0, 0], "normalizedVectors[1] delta not equal to 0 vector");
}
