module viare.graphics.image;

import viare.math.types;

class Image
{
	public:
		this(uint width, uint height, uint fill = 0xffffffff)
		{
			m_width = width;
			m_height = height;

			m_pixel.length = m_width;
			for(uint i = 0; i < m_width; i++)
			{
				m_pixel[i].length = m_height;

				for(uint j = 0; j < m_height; j++)
				{
					m_pixel[i][j] = fill;
				}
			}
		}

		ref uint opIndex(uint x, uint y)
		{
			return m_pixel[x][y];
		}

		uint[] linearize(MatrixOrder matrixOrder)()
		{
			uint[] linearization;
			static if(matrixOrder == MatrixOrder.RowMajor)
			{
				for(uint y = 0; y < m_height; y++)
				{
					for(uint x = 0; x < m_width; x++)
					{
						linearization ~= this[x, y];
					}
				}
			}
			static if(matrixOrder == MatrixOrder.ColumnMajor)
			{
				for(uint x = 0; x < m_width; x++)
				{
					for(uint y = 0; y < m_height; y++)
					{
						linearization ~= this[x, y];
					}
				}
			}
			return linearization;
		}

	private:
		uint[][] m_pixel;
		const uint m_width, m_height;
}
