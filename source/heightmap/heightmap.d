module viare.heightmap.heightmap;

import viare.heightmap.heightfunction;

class HeightMap
{
    private:
	float[][] m_height;
	const uint m_width;
	const uint m_height;

    public:
	this(uint width, uint height)
	{
	    m_width = width;
	    m_height = height;

	    m_height.length = width;
	    for(uint i = 0u; i < width; i++)
		m_height[i].length = height;
	}

	ref float opIndex(size_t i, size_t j)
	{
	    return m_height[i][j];
	}

	void fillByHeightFunction(HeightFunction heightFunction)
	{
	    for(uint i = 0; i < m_width; i++)
	    for(uint j = 0; j < m_height; j++)
		this[i, j] = heightFunction(cast(float) i / m_width, cast(float) j / m_height);
	}

	void normalize()
	{
	    float lowest = this[0, 0], highest = this[0, 0];

	    for(uint i = 0; i < m_width; i++)
	    for(uint j = 0; j < m_height; j++)
	    {
		if(this[i, j] < lowest)
		    lowest = this[i, j];
		if(this[i, j] > highest)
		    highest = this[i, j];
	    }

	    float maxRelativeHeight = highest - lowest;

	    for(uint i = 0; i < m_width; i++)
	    for(uint j = 0; j < m_height; j++)
		this[i, j] = (this[i, j] - lowest) / maxRelativeHeight;
	}
}

