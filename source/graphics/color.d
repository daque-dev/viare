module viare.graphics.color;

struct Color
{
	public:
		ubyte[4] c;

		ref ubyte r()
		{
			return c[0];
		}
		ref ubyte g()
		{
			return c[1];
		}
		ref ubyte b()
		{
			return c[2];
		}
		ref ubyte a()
		{
			return c[3];
		}

		this(ubyte r, ubyte g, ubyte b, ubyte a)
		{
			c[] = [r, g, b, a];
		}

		this(uint color)
		{
			for(uint i = 0; i < c.length; i++)
			{
				c[i] = color % 0x100;
				color >>= 8;
			}
		}

		uint toInt()
		{
			uint color = 0u;

			for(int i = c.length - 1; i >= 0; i--)
			{
				color += c[i];
				if(i - 1 >= 0)
					color <<= 8;
			}

			return color;
		}
}


