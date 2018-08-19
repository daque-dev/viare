module viare.vertex;

import std.conv;
import std.string;

import derelict.opengl;

import daque.graphics.opengl;

alias Vertex = Vert!"3f.0:position 4fn1:color";

// 3f.0:position 4fn1:color
struct MemberInfo
{
    string type;
    string identifier;

    string index;
    string size;
    string glType;
    string normalized;
}

MemberInfo getInfo(string memberString) pure nothrow
{
    string[] parts = split(memberString, ":");
    string first = parts[0];
    string second = parts[1];

    string type = (first[1] == 'f')? "float" : "float";
    string size = first[0 .. 1];

    MemberInfo info;
    info.type = type ~ "[" ~ size ~ "]";
    info.identifier = second;
    info.index = memberString[3 .. 4];
    info.size = size;
    info.glType = (type == "float")? "GL_FLOAT" : "GL_FLOAT";
    info.normalized = (memberString[2] == 'n')? "GL_TRUE" : "GL_FALSE";
    return info;
}
MemberInfo[] getInfos(string membersString) pure nothrow
{
    string[] memberString = split(membersString, " ");
    MemberInfo[] infos;
    foreach(str; memberString)
    {
        infos ~= getInfo(str);
    }
    return infos;
}

string attrFormatString(MemberInfo info)
{
    return "{ index: " ~ info.index ~
        ", size: " ~ info.size ~
        ", type: " ~ info.glType ~
        ", normalized: " ~ info.normalized ~
        ", stride: this.sizeof" ~
        ", pointer: cast(void*) this." ~ info.identifier ~ ".offsetof}";
}

string attrFormatStrings(MemberInfo[] infos)
{
    string str = "[";
    foreach(uint i, MemberInfo info; infos)
    {
        str ~= attrFormatString(info);
        if(i + 1 < infos.length)
            str ~= ", ";
    }
    str ~= "]";
    return str;
}

string declaration(MemberInfo info)
{
    return info.type ~ " " ~ info.identifier ~ ";";
}

string formStruct(string membersString)
{
    string structString;
    auto infos = getInfos(membersString);
    foreach(info; infos)
        structString ~= declaration(info);
    structString ~= "static AttributeFormat[] formats = " ~ attrFormatStrings(infos) ~ ";";
    return structString;
}

template Vert(string membersString)
{
    struct Vert
    {
        mixin(formStruct(membersString));
    }
}

unittest
{
    import std.stdio: writeln;
    Vert!"2fn0:position 4fn1:color" vert;
    vert.position[] = [3, 4];
    writeln(vert);
}

