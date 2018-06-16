module viare.math.geometry;

import std.traits;
import std.math;
import std.algorithm;
import std.algorithm.comparison;
import std.functional;
import std.array;
import std.stdio;
import std.conv;
import std.range;

deprecated alias Vector = float[3];

pure float dot(uint n)(in float[n] v, in float[n] w)
{
    float[n] products = v[] * w[];
    return products.array.sum;
}

pure float magnitude(uint n)(float[n] v)
{
    return sqrt(dot(v, v));
}

pure float distance(uint n)(float[n] v, float[n] w)
{
    float[n] difference = v[] - w[];
    return magnitude(difference);
}

pure float[n] normalize(uint n)(float[n] v)
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
    float[n] normalized =  v[] / magnitude (v);
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
