module abst.world;

import geometry;

/*
Common interface for world elements.
*/
interface IElement
{
};

/*
Common interface for 'World's, which are 3D array's of 'IElements'
*/
interface IWorld
{
    // Returns the element in the position (i, j, k)
    IElement getElement(int i, int j, int k);
    // Returns the size of the world
    Vector!uint getSize();
};
