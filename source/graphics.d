module viare.graphics;

import std.stdio;
import std.string;
import std.file;
import std.algorithm;

import derelict.opengl;
import derelict.sdl2.sdl;

import viare.geometry;


/*
@square function.
    Squares the given number, returns the result.
*/
double //square of @x
square
    (double x/*number to be squared*/)
{
    return x * x;
}

static this()
{
    DerelictSDL2.load();
    DerelictGL3.load();

    if(SDL_Init(SDL_INIT_EVERYTHING) < 0)
    {
	writeln("sdl init failed: ", fromStringz(SDL_GetError()));
    }
}

static ~this()
{
}

/*
@Window class.
    Represents a named rectangular drawing area.
*/
class Window
{
    public:

    /*
    @Window constructor.
	Constructs a new window with the specified dimensions (@width x @height) and name @name.
    */
	this
	    (string name, // name of the window to be constructed
	    uint width, // width of the window to be constructed
	    uint height) // height of the window to be constructed
	{
	    m_window = SDL_CreateWindow(name.toStringz(),
		SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
		width, height,
		SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL);

	    m_glContext = SDL_GL_CreateContext(m_window);

	    DerelictGL3.reload();
	}
    // Deallocates resources.
	~this()
	{
	    SDL_DestroyWindow(m_window);
	}

    private:
    // Internal SDL2 window handle.
	SDL_Window* m_window;
    // Internal SDL2-OpenGL Context handle.
	SDL_GLContext m_glContext;
}


/*
@Shader class.
    Represents a 'shader' OpenGL object.
	A shader is *part* of a program ought to be executed by the GPU.
	This class serves as a way to compile and use those program parts.

	The "whole" @Program is another OpenGL object constructed by assembling
	many 'Shader's.
*/
class Shader
{
    public:
    /*
    @Shader.Type enum.
    	Contains the types of @Shader there can be.
    */
	enum Type
	{
	    // Vertex Processing
	    Vertex,
	    // Fragment Processing
	    Fragment
	};

    /*
    @Shader.type method.
	Returns the type of the shader @this

    Inputs:
	none
    Ouputs:
	return(@Shader.Type):
	    shader type of shader represented by @this
    */
	@property Type type()
	{
	    return m_type;
	}

    /*
    @Shader constructor.
	Constructs a new shader of type @type, using as source code the file pointed to by
	@sourcePath

    Inputs:
	@type(@Shader.Type):
	    Type of the shader to be constructed
	@sourcePath(@string)
	    String representing a path to a file containing the source code which will be used as
	    source for the constructed shader
    Outputs:
	Constructs @this
    */
	this(Shader.Type type, string sourcePath)
	{
	    m_type = type;
	    m_shaderGlName = compileShader(type, sourcePath);
	}

    private:
    // Internal OpenGL Handle (aka name) to the shader object.
	GLuint m_shaderGlName;
    // Type of the shader.
	Type m_type;

    /*
    @Shader.compileShader function.
	Compiles a shader ot type @type, using as source code the file pointed to by @sourcePath and
	returns the name of the opengl object representing the compiled shader.

    Inputs:
	@type(@Shader.Type):
	    type of shader to be compiled
	@sourcePath(@string):
	    path to the shader's source code
    Outputs:
	return(@GLuint):
	    Opengl name of the compiled shader
    */
	static GLuint compileShader(Type type, string sourcePath)
	{
	    GLuint shaderName = glCreateShader(typeToGlenum(type));
	    const char* sourceCodeZ = toStringz(readText(sourcePath));
	    glShaderSource(shaderName, 1, &sourceCodeZ, null);
	    glCompileShader(shaderName);

	    GLint compilationSuccess = 0;
	    glGetShaderiv(shaderName, GL_COMPILE_STATUS, &compilationSuccess);
	    if(compilationSuccess == GL_FALSE)
	    {
		GLint logSize = 0;
		glGetShaderiv(shaderName, GL_INFO_LOG_LENGTH, &logSize);
		GLchar[] errorLog;
		errorLog.length = logSize;
		glGetShaderInfoLog(shaderName, logSize, &logSize, &errorLog[0]);
		char[] info = fromStringz(&errorLog[0]);
		writeln("compilation failed");
		writeln(info);
		glDeleteShader(shaderName);
	    }
	    else
	    {
		writeln("compilation success for : ", sourcePath);
	    }

	    return shaderName;
	}

    /*
    @Shader.typeToGlenum function.
	Maps @Shader.Type to equivalent OpenGL native @GLenum.

    Inputs:
	@type(@Shader.Type):
	    type value to be mapped to @GLenum
    Outputs:
	return(@GLenum):
	    @GLenum equivalent of @type
    */
	static pure GLenum typeToGlenum(Type type)
	{
	    switch(type)
	    {
		case Type.Vertex:
		    return GL_VERTEX_SHADER;
		case Type.Fragment:
		    return GL_FRAGMENT_SHADER;
	    }
	}
}

/*
@Buffer class.
    Represents a buffer opengl object.
	A buffer opengl object is the mechanism through which data can be stored in the GPU, usually
	vertex data of the models to be rendered.

	This class eases/abstracts the interaction with this kind of opengl objects.
*/
class Buffer
{
    public:
    /*
    @Buffer constructor.
	Constructs a new @Buffer.

    Inputs:
	none
    Outputs:
	Constructs @this
    */
	this()
	{
	    glGenBuffers(1, &m_bufferName);
	}
	~this()
	{
	    glDeleteBuffers(1, &m_bufferName);
	}

    /*
    @Buffer.bufferData method
	Sends the data pointed to by @data, and of size @size (in bytes) to @this buffer.

    Inputs:
	@data(@void*):
	    Pointer to the data to be sent
	@size(@size_t):
	    Size in bytes of the data to be sent
    Outpus:
	none
    */
	void bufferData(void* data, size_t size)
	{
	    bind();
	    glBufferData(GL_ARRAY_BUFFER, size, data, GL_DYNAMIC_DRAW);
	    unbind();
	}

	void bind()
	{
	    glBindBuffer(GL_ARRAY_BUFFER, m_bufferName);
	}

	void unbind()
	{
	    glBindBuffer(GL_ARRAY_BUFFER, 0);
	}

    private:
    // opengl name of the buffer managed by @this
	GLuint m_bufferName;
}

/*
@Vertex struct.
    Gives the necessary information to represent a Vertex in a 3D model.
*/
struct Vertex
{
    // Position of the vertex
    Vector!float position;
    // Color of the vertex
    Vector!float color;

    /*
	OpenGL requires us to give it the format in which data is stored in GPU.
	Vertex.formats provides this information about this Vertex format in particular.

	Note it is a *static* property of the Vertex structure, not of instances.

	OpenGL thinks of every Vertex as having _attributes_, as we think of _members_ of a struct.
	This Vertex struct contains two _attributes_, they are the @position and the @color.

	See @AttributeFormat for more info about the data needed by OpenGL.
    */
    static AttributeFormat[] formats = 
    [
	//position attribute format
	{
	    index: 0, 
	    size: 3, 
	    type: GL_FLOAT, 
	    normalized: GL_FALSE, 
	    stride: cast(GLsizei)Vertex.sizeof, 
	    pointer: cast(void*)Vertex.position.offsetof
	    /*
	    EXPLANATION:
		position is the attribute no. 0, contains 3 components each of type float which
		won't (GL_FALSE) be normalized.
	    */
	},
	//color attribute format
	{
	    index: 1, 
	    size: 3, 
	    type: GL_FLOAT, 
	    normalized: GL_TRUE, 
	    stride: cast(GLsizei)Vertex.sizeof, 
	    pointer: cast(void*)Vertex.color.offsetof
	}
    ];
};

/*
@AttributeFormat
    Data needed to represent a particular attribute for a Vertex.
*/
struct AttributeFormat
{
    // OpenGL identifies each attribute by an @index
    GLuint index;
    // No. of components of this attribute
    GLint size;
    // Data type of the components of this attribute
    GLenum type;
    // Does it need to be _normalized_(Clipped to a range of 0.0 - 1.0)?
    GLboolean normalized;
    // Space between each appearance of this attribute in an array of Vertices, equivalently, the
    // size of each Vertex
    GLsizei stride;
    // Offset to first appearance of this attribute in an array of Vertices, equivalently, the
    // offset of this member in the Vertex structure
    const GLvoid* pointer;
};

/*
@setup function.
    Given the @Buffer and the @VertexArray bound to the OpenGL context, this function provides
    format info about the attribute @format.index of the vertices in the VertexArray.

    This associates the @Buffer to the @VertexArray.

Inputs:
    @format(@AttributeFormat):
	attribute format to be given to the @VertexArray currently bound

    _implicit_ _*REQUIRED*_ currently bound @VertexArray object:
	VertexArray to be formatted
    _implicit_ _*REQUIRED*_ currently bound @Buffer object:
	Buffer from which to get the data pointer
Outputs:
    none
*/
void setup(AttributeFormat format)
{
    glEnableVertexAttribArray(format.index);

    glVertexAttribPointer(format.index,
	format.size, format.type,
	format.normalized,
	format.stride,
	format.pointer);
}

class VertexArray
{
    public:
	this()
	{
	    glGenVertexArrays(1, &m_vertexArrayName);
	}
	~this()
	{
	    glDeleteVertexArrays(1, &m_vertexArrayName);
	}

	void use(Buffer buffer)
	{
	    bind();
	    buffer.bind();
	    Vertex.formats.each!setup;
	    buffer.unbind();
	    unbind();
	}

	void bind()
	{
	    glBindVertexArray(m_vertexArrayName);
	}
	void unbind()
	{
	    glBindVertexArray(0);
	}

    private:
	GLuint m_vertexArrayName;
}
