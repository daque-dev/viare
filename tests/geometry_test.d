import geometry;

// Just one import, but one unittest for every "important"
// aspect implemented in the imported module

unittest
{
    assert( euclideanDistance([1, 2], [3, 4]) == 2.2 );
    assert( Vector!int(1, 2, 3).y == 2);
}