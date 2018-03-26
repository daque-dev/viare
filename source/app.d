// Core of the game

import std.stdio;
import abst.world;
import geometry;

void receiveWorld(IWorld world)
{
    writeln("received a world of size ", world.getSize());
}

void main()
{
    writeln("welcome to unnamed");
}
