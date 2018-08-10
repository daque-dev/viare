module viare.models;

import daque.math.geometry;

import viare.graphics.opengl;

immutable(Vertex)[] SQUARE_VERTICES = [// 1st triangle
{position:
[-1, -1, 0], uv : [0, 0]}, {position:
[+1, -1, 0], uv : [1, 0]}, {position:
[-1, +1, 0], uv : [0, 1]},// 2nd triangle
{position:
[+1, +1, 0], uv : [1, 1]}, {position:
[+1, -1, 0], uv : [1, 0]}, {position:
[-1, +1, 0], uv : [0, 1]}];
