module abst.world;

import geometry;

interface IElement
{
};

interface IWorld
{
    IElement getElement(int i, int j, int k);
    Vector!uint getSize();
};
