module viare.heightmap.heightmap;

import viare.heightmap.heightfunction;

class HeightMap
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

			m_height.length = width;
			for(uint i; i < width; i++)
				m_height[i].length = height;

			for(uint i; i < width; i++)
				for(uint j; j < height; j++)
					this[i, j] = 0.0f;
		}

		uint getWidth()
		{
			return m_xlength;
		}
		uint getHeight()
		{
			return m_ylength;
		}

		ref float opIndex(size_t i, size_t j)
		{
			return m_height[i][j];
		}

		void fillByHeightFunction(HeightFunction heightFunction)
		{
			for(uint i; i < m_xlength; i++)
				for(uint j; j < m_ylength; j++)
					this[i, j] = heightFunction(cast(float) i / m_xlength, cast(float) j / m_ylength);
		}

		void normalize()
		{
			float lowest = this[0, 0], highest = this[0, 0];

			for(uint i; i < m_xlength; i++)
				for(uint j; j < m_ylength; j++)
				{
					if(this[i, j] < lowest)
						lowest = this[i, j];
					if(this[i, j] > highest)
						highest = this[i, j];
				}

			immutable float maxRelativeHeight = highest - lowest;

			for(uint i; i < m_xlength; i++)
				for(uint j; j < m_ylength; j++)
					this[i, j] = (this[i, j] - lowest) / maxRelativeHeight;
		}
}

