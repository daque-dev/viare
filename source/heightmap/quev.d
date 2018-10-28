module viare.heightmap.quev;

import std.random;
import std.math;

import daque.math.geometry;
import viare.heightmap.heightfunction;

struct QuevCenter
{
    double[2] position;
    double weight;
    double base;
    double exponent;
    double zoom;
}

interface QuevCentersGenerator
{
    QuevCenter[] opCall(uint noCenters);
}

class StdQuevCentersGenerator : QuevCentersGenerator
{
private:
    Parameters m_parameters;
public:
    struct Parameters
    {
        double[2]delegate() position_generator;
        double delegate() weight_generator;
        double delegate() base_generator;
        double delegate() exponent_generator;
        double delegate() zoom_generator;
    }

    static Parameters default_parameters;

    static this()
    {
        default_parameters.position_generator = {
            double x = uniform!"[)"(0.0, 1.0);
            double y = uniform!"[)"(0.0, 1.0);
            double[2] position = [x, y];
            return position;
        };
        default_parameters.weight_generator = { return uniform!"[]"(-1.0, 1.0); };
        default_parameters.base_generator = { return uniform!"[]"(1000.1, 1000.2); };
        default_parameters.exponent_generator = { return uniform!"[]"(1.2, 5.6); };
        default_parameters.zoom_generator = { return uniform!"[]"(0.125, 0.175); };
    }

    this(Parameters parameters)
    {
        m_parameters = parameters;
    }

    this()
    {
        this(default_parameters);
    }

    QuevCenter[] opCall(uint no_centers)
    {
        QuevCenter[] centers;
        for (uint center_number; center_number < no_centers; center_number++)
        {
            QuevCenter center;
            center.position[] = m_parameters.position_generator()[];
            center.weight = m_parameters.weight_generator();
            center.base = m_parameters.base_generator();
            center.exponent = m_parameters.exponent_generator();
            center.zoom = m_parameters.zoom_generator();
            centers ~= center;
        }
        return centers;
    }
}

class QuevHeightFunction : HeightFunction
{
private:
    QuevCenter[] m_centers;
    double[] m_threshholds;

    static immutable epsilon = 0.01;
public:

    this(QuevCenter[] centers)
    {
        m_centers.length = centers.length;
        m_centers[] = centers[];

        m_threshholds.length = m_centers.length;

        foreach (uint i, QuevCenter center; m_centers)
        {
            m_threshholds[i] = center.zoom * pow(-log(epsilon / abs(
                    center.weight)) / log(center.base), 1.0 / center.exponent);
        }
    }

    double opCall(double x, double y)
    {
        double[2] point = [x, y];
        double total = 0.0;

        foreach (uint i, QuevCenter center; m_centers)
        {
            immutable distance_to_center = distance!double(point, center.position);
            if (distance_to_center > m_threshholds[i])
                continue;

            total += center.weight * pow(center.base,
                    -pow(distance_to_center / center.zoom, center.exponent));
        }
        return total;
    }
}
