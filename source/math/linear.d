module viare.linear;

struct Matrix(T, N, M)
{
    this(T[N][M] data)
    {
        m_data = data;
    }

    this()
    {
        for(uint i; i < N; i++)
        {
            for(uint j; j < M; j++)
            {
                if (i == j)
                    this[i, j] = 1;
                else
                    this[i, j] = 0;
            }
        }
    }

    T opIndex(uint i, uint j)
    {
        return m_data[i][j];
    }
private:
    immutable T[N][M] m_data;
}