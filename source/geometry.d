module viare.geometry;

import std.traits;
import std.math;
import std.algorithm;
import std.functional;
import std.array;

alias Vector = float[3];

double magnitude(Vector v){
    return pipe!(array,
        map!(a => cast(real)(a)),
        map!(a => a * a),
        sum, sqrt)(v);
}

auto normalize(Vector v){
    Vector r =  v[] / magnitude (v);
    return r;
    }

unittest
{
    // Consider floating point accuracy problems.
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
    assert(abs(magnitudes[0] - sqrt(14.0)) < tolerance && magnitudes[0] >= 0);
    assert(abs(magnitudes[1] - sqrt(14.0)) < tolerance && magnitudes[0] >= 0);
    assert(abs(magnitudes[2] - sqrt(3.0))  < tolerance && magnitudes[0] >= 0);
    assert(abs(magnitudes[3]) < tolerance);
   
    // Normalization
    auto normalized = map!normalize(vectors).array;
    // float[][] result = normalized [] - [cast(float) (3.0 / sqrt(14.0)), cast(float) (1.0 /sqrt(14.0)),cast(float) sqrt(2.0/7.0)];
}
