module viare.heightmap.renderer;

import daque.graphics.image;
import daque.graphics.color;

import viare.heightmap.heightmap;

import viare.vertex;

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
                color.component[0 .. 3] = map!(c => cast(ubyte) c)(colorFloat[])
                    .array;
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

    Vertex[] getMesh(float height, float[2] size, HeightMap hm)
    {
        immutable hmWidth = hm.getWidth();
        immutable hmHeight = hm.getHeight();
        float[2] getBase(uint i, uint j)
        {
            float[2] base;
            base[0] = (i + 1.0f) / (hmWidth + 1.0f) * size[0] - size[0] * 0.5f;
            base[1] = (j + 1.0f) / (hmHeight + 1.0f) * size[1] - size[1] * 0.5f;
            return base;
        }
        Vertex getVertex(uint i, uint j)
        {
            auto base = getBase(i, j);
            float normalHeight = hm[i, j];
            float pointHeight = normalHeight * height;
            bool isWater = (normalHeight <= m_waterLevel);
            auto tint = isWater? m_waterTint: m_terrainTint;

            immutable heightPerDivision = 1.0f / cast(float) m_divisions;
            immutable uint division = normalHeight == 1.0f ? m_divisions - 1
                : cast(uint)(normalHeight / heightPerDivision);

            pointHeight = heightPerDivision * division * height;

            Vertex v;
            v.position[] = [base[0], pointHeight, base[1]];
            v.color[0 .. 3] = heightPerDivision * division * tint[];
            v.color[3] = 1.0f;
            return v;
        }

        Vertex[] mesh;
        for(uint i; i + 1 < hmWidth; i++)
        {
            for(uint j; j + 1 < hmHeight; j++)
            {
                Vertex[2][2] v;
                for(uint di; di < 2; di++)
                    for(uint dj; dj < 2; dj++)
                        v[di][dj] = getVertex(i + di, j + dj);
                mesh ~= v[0][0];
                mesh ~= v[1][0];
                mesh ~= v[0][1];

                mesh ~= v[1][0];
                mesh ~= v[1][1];
                mesh ~= v[0][1];
            }
        }
        return mesh;
    }

private:
    float[3] m_waterTint, m_terrainTint;
    float m_waterLevel;
    uint m_divisions = 0x100;
}
