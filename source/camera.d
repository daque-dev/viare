module viare.camera;

import daque.math.quaternion;
import daque.math.geometry;
import daque.math.linear;

struct Camera
{
    Quaternion!float orientation = Quaternion!float.getRotation([1, 0, 0], 0);
    float[3] position = 0;
}
