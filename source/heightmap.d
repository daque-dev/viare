module viare.heightmap;

import std.math;
import std.random;

import viare.math;

interface HeightFunction
{
	double opCall(double x, double y);
}

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
			double x = uniform!"[)"(0.0, 400.0);
			double y = uniform!"[)"(0.0, 400.0);
			double[2] position = [x, y];
			return position;
		};
		defaultParams.weightGenerator = { return uniform!"[]"(-100.0, 100.0); };
		defaultParams.baseGenerator = { return uniform!"[]"(1.1, 1.7); };
		defaultParams.exponentGenerator = { return uniform!"[]"(3.0, 7.0); };
		defaultParams.zoomGenerator = { return uniform!"[]"(50.0, 70.0); };
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
	public:
		this(QuevCenter[] centers)
		{
			m_centers.length = centers.length;
			m_centers[] = centers[];
		}

		double opCall(double x, double y)
		{
			double[2] point = [x, y];
			double total = 0.0;
			foreach(QuevCenter center; m_centers)
			{
				double distance = distance(point, center.position);

				distance /= center.zoom;

				total += 
				center.weight * 
				pow(center.base, -pow(distance, center.exponent));
			}
			return total;
		}
}
