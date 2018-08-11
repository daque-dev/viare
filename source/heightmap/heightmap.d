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

			import std.algorithm;

			m_height.length = width;
			m_height.each!((ref column)=>column.length = height);
			m_height.each!((ref column)=>column.each!((ref element)=>element=0));
		}

		uint getWidth()
		{
			return m_xlength;
		}
		uint getHeight()
		{
			return m_ylength;
		}

		ref float opIndex(uint i, uint j)
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

			immutable maxRelativeHeight = highest - lowest;

			for(uint i; i < m_xlength; i++)
				for(uint j; j < m_ylength; j++)
					this[i, j] = (this[i, j] - lowest) / maxRelativeHeight;
		}
}

