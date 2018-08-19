module viare.vertex;

struct Vertex
{
    float[3] position;
    float[4] color;
    static AttributeFormat[] formats = [{
        index: 0,
        size: 3,
        type: GL_FLOAT,
        normalized: GL_FALSE,
        stride: Vertex.sizeof,
        pointer: cast(void*) Vertex.position.offsetof
    }, {
        index: 1,
        size : 4,
        type : GL_FLOAT,
        normalized : GL_TRUE,
        stride : Vertex.sizeof,
        pointer : cast(void*) Vertex.color.offsetof
    }];
}

