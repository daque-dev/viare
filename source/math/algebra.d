module viare.math.algebra;

import std.functional;

pure float sigma(alias F)(int n, int N)
if(isFunction!F && functionAttributes!F & FunctionAttribute.pure_)
{
    float r = 0;
    for(int i = n; i < N; i++)
	r += F(i);
    return r;
}


