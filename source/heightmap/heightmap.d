module viare.heightmap.heightmap;

import viare.heightmap.heightfunction;

class Heightmap
{
private:
    float[][] m_height;
    const uint m_xlength;
    const uint m_ylength;

public:

    this(uint width, uint height)
    {
        m_xlength = width;
        m_ylength = height;

        import std.algorithm;

        m_height.length = width;
        m_height.each!((ref column) => column.length = height);
        m_height.each!((ref column) => column.each!((ref element) => element = 0));
    }

    uint Get_Width()
    {
        return m_xlength;
    }

    uint Get_Height()
    {
        return m_ylength;
    }

    ref float opIndex(uint i, uint j)
    {
        return m_height[i][j];
    }

    void Fill_By_Height_Function(HeightFunction height_function)
    {
        for (uint i; i < m_xlength; i++)
        {
            for (uint j; j < m_ylength; j++)
            {
                version(Windows)
                {
                    import std.stdio;
                    writeln(cast(double)i / m_xlength);    /// Don't know why. But fixes problem
                }
                this[i, j] = height_function(cast(double) i / m_xlength, cast(double) j / m_ylength);
            }
        }
    }

    void Normalize()
    {
        float lowest = this[0, 0], highest = this[0, 0];

        for (uint i; i < m_xlength; i++)
        {
            for (uint j; j < m_ylength; j++)
            {
                if (this[i, j] < lowest)
                {
                    lowest = this[i, j];
                }

                if (this[i, j] > highest)
                {
                    highest = this[i, j];
                }
            }
        }

        immutable max_relative_height = highest - lowest;

        for (uint i; i < m_xlength; i++)
        {
            for (uint j; j < m_ylength; j++)
            {
                this[i, j] = (this[i, j] - lowest) / max_relative_height;
            }
        }
    }
}
