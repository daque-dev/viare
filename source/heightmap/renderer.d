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
	/++
		Renders a HeightMap into an Image

		Params:
		heightMap = heightmap to be rendered

		Returns:
		The image on which the heightmap was rendered
	+/
		Image render(HeightMap heightMap)
		{
			immutable heightMapWidth = heightMap.getWidth();
			immutable heightMapHeight = heightMap.getHeight();
			Image image = new Image(heightMapWidth, heightMapHeight);

			for(uint x; x < heightMapWidth; x++)
			{
				for(uint y; y < heightMapHeight; y++)
				{
					immutable cellHeight = heightMap[x, y];
					immutable bool isWater = (cellHeight <= m_waterLevel);
					immutable float[3] tint = isWater? m_waterTint: m_terrainTint;
					immutable float[3] colorFloat = tint[] * (cellHeight * 0xFF);

					Color color;
					for(uint i; i < 3; i++)
						color.component[i] = cast(ubyte) colorFloat[i];
					color.component[3] = 0xFF;

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

