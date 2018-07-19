module viare.heightmap.renderer;

import viare.graphics.image;
import viare.graphics.color;
import viare.heightmap.heightmap;

interface HeightMapRenderer
{
	public:
		Image render(HeightMap heightMap);
}

class WaterTerrainHeightMapRenderer: HeightMapRenderer
{
	public:
		Image render(HeightMap heightMap)
		{
			uint width = heightMap.getWidth();
			uint height = heightMap.getHeight();
			Image image = new Image(width, height);

			for(uint x = 0; x < width; x++)
			{
				for(uint y = 0; y < height; y++)
				{
					float cellHeight = heightMap[x, y];
					bool isWater = (cellHeight <= m_waterLevel);
					float[3] tint;
					if(isWater)
						tint[] = m_waterTint[];
					else
						tint[] = m_terrainTint[];
					Color color;
					float[3] colorFloat = tint[] * (cellHeight * 0xFF);
					for(uint i = 0; i < 3; i++)
						color.c[i] = cast(ubyte) colorFloat[i];
					color.c[3] = 0xFF;
					image[x, y] = color.toInt();
				}
			}

			return image;
		}

		void setWaterLevel(float waterLevel)
		{
			m_waterLevel = waterLevel;
		}
		void setWaterTint(float[3] waterTint)
		{
			m_waterTint[] = waterTint[];
		}
		void setTerrainTint(float[3] terrainTint)
		{
			m_terrainTint[] = terrainTint[];
		}

	private:
		float[3] m_waterTint, m_terrainTint;
		float m_waterLevel;
}

