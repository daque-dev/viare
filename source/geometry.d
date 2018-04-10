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

pure float dot(in Vector v, in Vector w)
{
    Vector products = v[] * w[];
    return products.array.sum;
}

pure float magnitude(Vector v)
{
    return sqrt(dot(v, v));
}

pure Vector normalize(Vector v)
in
{
    assert(v.magnitude > 0.0f, "cannot normalize a zero vector");
}
out(result)
{
    assert(approxEqual(result.magnitude, 1.0f));
}
do
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
   
    // Normalization
    auto normalizeds = map!normalize(vectors.take(3));

    Vector[] expected;
    expected.length = 3;
    expected[0] = [3.0f, 1.0f, 2.0f] / sqrt(14.0f);
    expected[1] = [-3.0f, -1.0f, -2.0f] / sqrt(14.0f);
    expected[2] = [1.0f, 1.0f, 1.0f] / sqrt(3.0f);

    assert(equal(expected, normalizeds));
}
