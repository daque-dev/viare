module viare.graphics;

import std.stdio;
import std.string;
import std.file;

import derelict.opengl;
import derelict.sdl2.sdl;

import viare.geometry;

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

class Window
{
    public:
	this(string name, uint width, uint height)
	{
	    m_window = SDL_CreateWindow(name.toStringz(),
		SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
		width, height,
		SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL);

	    m_glContext = SDL_GL_CreateContext(m_window);

	    DerelictGL3.reload();
	}
	~this()
	{
	    SDL_DestroyWindow(m_window);
	}

    private:
	SDL_Window* m_window;
	SDL_GLContext m_glContext;
}


class Shader
{
    public:
	enum Type
	{
	    Vertex, Fragment
	};
	Type type;

	this(Shader.Type type, string sourcePath)
	{
	    this.type = type;
	    m_shaderGlName = compileShader(type, sourcePath);
	}

    private:
	string m_sourceCode;
	GLuint m_shaderGlName;

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

	static GLenum typeToGlenum(Type type)
	{
	    switch(type)
	    {
		case Type.Vertex:
		    return GL_VERTEX_SHADER;
		case Type.Fragment:
		    return GL_FRAGMENT_SHADER;
		default:
		    return GL_VERTEX_SHADER;
	    }
	}
}

class Buffer
{
    public:
	this()
	{
	    glGenBuffers(1, &m_bufferName);
	}
	~this()
	{
	    glDeleteBuffers(1, &m_bufferName);
	}

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
	GLuint m_bufferName;
}

struct Vertex
{
    Vector!float position;
    Vector!float color;
};

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
	    glEnableVertexAttribArray(0);
	    glEnableVertexAttribArray(1);
	    buffer.bind();
	    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, cast(GLsizei) Vertex.sizeof, cast(void*) Vertex.position.offsetof);
	    glVertexAttribPointer(1, 3, GL_FLOAT, GL_TRUE, cast(GLsizei) Vertex.sizeof, cast(void*) Vertex.color.offsetof);
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
