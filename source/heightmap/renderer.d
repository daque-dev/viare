module viare.heightmap.renderer;

import daque.graphics.image;
import daque.graphics.color;

import viare.heightmap.heightmap;

interface HeightMapRenderer
{
public:
	Image render(HeightMap heightMap);
}

class WaterTerrainHeightMapRenderer : HeightMapRenderer
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

		for (uint x; x < heightMapWidth; x++)
		{
			for (uint y; y < heightMapHeight; y++)
			{
				immutable cellHeight = heightMap[x, y];
				immutable bool isWater = (cellHeight <= m_waterLevel);
				immutable float[3] tint = isWater ? m_waterTint : m_terrainTint;
				assert(m_divisions != 0);
				immutable heightPerDivision = 1.0f / cast(float) m_divisions;
				immutable uint division = cellHeight == 1.0f ? m_divisions - 1
					: cast(uint)(cellHeight / heightPerDivision);
				immutable float[3] colorFloat = tint[] * (division * heightPerDivision * 0xFF);

				import std.algorithm;
				import std.array;

				Color color;
				color.component[0 .. 3] = map!(c => cast(ubyte) c)(colorFloat[]).array;
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

	void setDivisions(uint divisions)
	{
		m_divisions = divisions;
	}

private:
	float[3] m_waterTint, m_terrainTint;
	float m_waterLevel;
	uint m_divisions = 0x100;
}
