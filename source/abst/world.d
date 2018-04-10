module viare.abst.world;

import viare.math.geometry;

/*
Common interface for 'World's, which are 3D array's of 'Tile's
*/
interface IWorld
{
    // Returns the element in the position (i, j, k)
    Tile getTile(int i, int j, int k);
    // Returns the size of the world
    uint[3] getSize();
}

struct Tile
{
    AmbientInfo ambientInfo;

    IElement element;
    IBiome biome;
}

/*
Common interface for world elements.
*/
interface IElement
{
}

/*
*/
interface IBiome
{
}

/*
*/
struct AmbientInfo
{
    double temperature;
}
