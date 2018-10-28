module viare.heightmap.renderer;

import daque.graphics.image;
import daque.graphics.color;

import viare.heightmap.heightmap;

struct WaterTerrainHeightmapRenderSettings
{
public:
    float[3] water_tint = [0.0, 0.0, 1.0], terrain_tint = [0.0, 1.0, 0.0];
    float water_level = 0.0f;
    uint divisions = 0x100;
}

struct Vertex 
{
    float[3] position;
    float[4] color;
}

Vertex[] Get_Heightmap_Mesh(WaterTerrainHeightmapRenderSettings render_settings, float height, float[2] size, Heightmap heightmap)
{
    immutable heightmap_width = heightmap.Get_Width();
    immutable heightmap_height = heightmap.Get_Height();

    float[2] Get_Base(uint i, uint j)
    {
        float[2] base;
        base[0] = (i + 1.0f) / (heightmap_width + 1.0f) * size[0] - size[0] * 0.5f;
        base[1] = (j + 1.0f) / (heightmap_height + 1.0f) * size[1] - size[1] * 0.5f;
        return base;
    }

    Vertex Get_Vertex(uint i, uint j)
    {
        auto base = Get_Base(i, j);
        float normal_height = heightmap[i, j];
        float point_height = normal_height * height;
        bool is_water = (normal_height <= render_settings.water_level);
        auto tint = is_water? render_settings.water_tint: render_settings.terrain_tint;

        immutable height_per_division = 1.0f / cast(float) render_settings.divisions;
        immutable uint division = 
            normal_height == 1.0f ? 
                render_settings.divisions - 1
            : 
                cast(uint)(normal_height / height_per_division);

        point_height = height_per_division * division * height;

        Vertex vertex;
        vertex.position[] = [base[0], point_height, base[1]];
        vertex.color[0 .. 3] = height_per_division * division * tint[];
        vertex.color[3] = 1.0f;
        return vertex;
    }

    Vertex[] mesh;
    for(uint i; i + 1 < heightmap_width; i++)
    {
        for(uint j; j + 1 < heightmap_height; j++)
        {
            Vertex[2][2] vertex;

            for(uint di; di < 2; di++)
            {
                for(uint dj; dj < 2; dj++)
                {
                    vertex[di][dj] = Get_Vertex(i + di, j + dj);
                }
            }

            mesh ~= vertex[0][0];
            mesh ~= vertex[1][0];
            mesh ~= vertex[0][1];

            mesh ~= vertex[1][0];
            mesh ~= vertex[1][1];
            mesh ~= vertex[0][1];
        }
    }

    return mesh;
}
/++
    Renders a Heightmap into an Image

    Params:
    heightMap = heightmap to be rendered

    Returns:
    The image on which the heightmap was rendered
+/

Image Render(WaterTerrainHeightmapRenderSettings render_settings, Heightmap heightmap)
{
    immutable heightmap_width = heightmap.Get_Width();
    immutable heightmap_height = heightmap.Get_Height();
    Image image = new Image(heightmap_width, heightmap_height);

    for (uint x; x < heightmap_width; x++)
    {
        for (uint y; y < heightmap_height; y++)
        {
            immutable cell_height = heightmap[x, y];

            immutable bool is_water = (cell_height <= render_settings.water_level);

            immutable float[3] tint = is_water ? render_settings.water_tint : render_settings.terrain_tint;

            assert(render_settings.divisions != 0);

            immutable height_per_division = 1.0f / cast(float) render_settings.divisions;

            immutable uint division = 
                cell_height == 1.0f? 
                    render_settings.divisions - 1
                : 
                    cast(uint)(cell_height / height_per_division);

            immutable float[3] color_float = tint[] * (division * height_per_division * 0xFF);

            import std.algorithm;
            import std.array;

            Color color;
            color.component[0 .. 3] = map!(c => cast(ubyte) c)(color_float[]).array;
            color.component[3] = 0xFF;

            image[x, y] = color.toInt();
        }
    }

    return image;
}
