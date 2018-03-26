module abst.world;

import geometry;

/*
Common interface for 'World's, which are 3D array's of 'IElements'
*/
interface IWorld
{
    // Returns the element in the position (i, j, k)
    Tile getTile(int i, int j, int k);
    // Returns the size of the world
    Vector!uint getSize();
}

struct Tile
{
    BiomeInfo biomeInfo;
    AmbientInfo ambientInfo;
    IElement element;
}

/*
Common interface for world elements.
*/
interface IElement
{
}

struct BiomeInfo
{
    enum Type {
	FreshWater, Forest
    };
    Type type;
}

struct AmbientInfo
{
    double temperature;
}


