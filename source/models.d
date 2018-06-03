module viare.models;

import viare.math.geometry;
import viare.graphics;


immutable(Vertex)[] SQUARE_VERTICES = [
    // 1st triangle
    {
	position: [-1.0, -1.0, 0],
	uv: [0, 0]
    },
    {
	position: [+1.0, -1.0, 0],
	uv: [1, 0]
    },
    {
	position: [-1.0, +1.0, 0],
	uv: [0, 1]
    },

    // 2nd triangle
    {
	position: [+0.5, +0.5, 0],
	uv: [1, 1]
    },
    {
	position: [+1, -1, 0],
	uv: [1, 0]
    },
    {
	position: [-1, +1, 0],
	uv: [0, 1]
    }
];
