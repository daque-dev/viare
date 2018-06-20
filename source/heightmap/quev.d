module viare.heightmap.quev;

import std.random;
import std.math;

import viare.math.geometry;
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
	Params m_params;
public:
	struct Params
	{
		double[2] delegate() positionGenerator;
		double delegate() weightGenerator;
		double delegate() baseGenerator;
		double delegate() exponentGenerator;
		double delegate() zoomGenerator;
	}

	static Params defaultParams;

	static this()
	{
		defaultParams.positionGenerator = { 
			double x = uniform!"[)"(0.0, 1.0);
			double y = uniform!"[)"(0.0, 1.0);
			double[2] position = [x, y];
			return position;
		};
		defaultParams.weightGenerator = { return uniform!"[]"(-1.0, 1.0); };
		defaultParams.baseGenerator = { return uniform!"[]"(20.1, 40.2); };
		defaultParams.exponentGenerator = { return uniform!"[]"(1.2, 1.5); };
		defaultParams.zoomGenerator = { return uniform!"[]"(0.125, 0.175); };
	}

	this(Params params)
	{
		m_params = params;
	}
	this()
	{
		this(defaultParams);
	}
	QuevCenter[] opCall(uint noCenters)
	{
		QuevCenter[] centers;
		for(uint centerNo = 0; centerNo < noCenters; centerNo++)
		{
			QuevCenter newCenter;
			newCenter.position[] = m_params.positionGenerator()[];
			newCenter.weight = m_params.weightGenerator();
			newCenter.base = m_params.baseGenerator();
			newCenter.exponent = m_params.exponentGenerator();
			newCenter.zoom = m_params.zoomGenerator();
			centers ~= newCenter;
		}
		return centers;
	}
}

class QuevHeightFunction : HeightFunction
{
	private:
		QuevCenter[] m_centers;
		double[] m_threshholds;

		static double epsilon = 0.01;
	public:
		this(QuevCenter[] centers)
		{
			m_centers.length = centers.length;
			m_centers[] = centers[];

			m_threshholds.length = m_centers.length;

			for(uint i = 0u; i < m_centers.length; i++)
			{
			    m_threshholds[i] = m_centers[i].zoom * 
				pow(-log(epsilon/abs(m_centers[i].weight))/log(m_centers[i].base),
					1.0/m_centers[i].exponent);
			}
		}

		double opCall(double x, double y)
		{
			double[2] point = [x, y];
			double total = 0.0;
			for(uint i = 0; i < m_centers.length; i++)
			{
				QuevCenter center = m_centers[i];
				double distance = distance(point, center.position);
				if(distance > m_threshholds[i])
				    continue;

				distance /= center.zoom;

				total += 
				center.weight * 
				pow(center.base, -pow(distance, center.exponent));
			}
			return total;
		}
}
