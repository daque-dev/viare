module viare.vertex;

import std.conv;
import std.string;

import derelict.opengl;

import daque.graphics.opengl;

alias Vertex = DefineVertex!"3f.0:position 4fn1:color";

// 3f.0:position 4fn1:color
struct MemberInfo
{
    string type;
    string identifier;
    string index;
    string size;
    string gl_type;
    string normalized;
}

MemberInfo Get_Info(string member_string) pure nothrow
{
    string[] parts = split(member_string, ":");
    string first = parts[0];
    string second = parts[1];

    string type = (first[1] == 'f')? "float" : "float";
    string size = first[0 .. 1];

    MemberInfo info = {
        type: type ~ "[" ~ size ~ "]",
        identifier: second,
        index: member_string[3 .. 4],
        size: size,
        gl_type: (type == "float")? "GL_FLOAT" : "GL_FLOAT",
        normalized: (member_string[2] == 'n')? "GL_TRUE" : "GL_FALSE"
    };
    return info;
}

MemberInfo[] Get_Infos(string members_string) pure nothrow
{
    string[] member_string = split(members_string, " ");
    MemberInfo[] infos;
    foreach(str; member_string)
    {
        infos ~= Get_Info(str);
    }
    return infos;
}

string Get_AttributeFormat_String(MemberInfo info)
{
    return "{ index: " ~ info.index ~
        ", size: " ~ info.size ~
        ", type: " ~ info.gl_type ~
        ", normalized: " ~ info.normalized ~
        ", stride: this.sizeof" ~
        ", pointer: cast(void*) this." ~ info.identifier ~ ".offsetof}";
}

string Get_AttributeFormat_Strings(MemberInfo[] infos)
{
    string str = "[";
    foreach(uint i, MemberInfo info; infos)
    {
        str ~= Get_AttributeFormat_String(info);
        if(i + 1 < infos.length)
            str ~= ", ";
    }
    str ~= "]";
    return str;
}

string Get_Declaration(MemberInfo info)
{
    return info.type ~ " " ~ info.identifier ~ ";";
}

string Form_Struct(string members_string)
{
    string struct_string;
    auto infos = Get_Infos(members_string);
    foreach(info; infos)
        struct_string ~= Get_Declaration(info);
    struct_string ~= "static AttributeFormat[] formats = " ~ Get_AttributeFormat_Strings(infos) ~ ";";
    return struct_string;
}

struct DefineVertex(string members_string)
{
	 mixin(Form_Struct(members_string));
}

unittest
{
    import std.stdio: writeln;
    Vert!"2fn0:position 4fn1:color" vert;
    vert.position[] = [3, 4];
    writeln(vert);
}

