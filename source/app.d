// Core of the game

import std.stdio;
import abst.world;
import geometry;

class Rock : IElement
{
    override string toString()
    {
	return "i am rock";
    }
};

class World100 : IWorld
{
    public this()
    {
    }

    Vector!uint getSize() 
    {
	Vector!uint size = { x: 100, y: 100, z: 100 };
	return size;
    }

    IElement getElement(int i, int j, int k)
    {
	return rock;
    }

    Rock rock;
};

void receiveWorld(IWorld world)
{
    writeln("received a world of size ", world.getSize());
}

void main()
{
    IWorld world = new World100();
    receiveWorld(world);
}
