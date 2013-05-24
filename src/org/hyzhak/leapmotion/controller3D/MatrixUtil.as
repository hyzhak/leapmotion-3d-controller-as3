package org.hyzhak.leapmotion.controller3D {
    import com.leapmotion.leap.Matrix;
    import com.leapmotion.leap.Vector3;

    public class MatrixUtil {
        /**
         * Transforms a vector with this matrix by transforming its rotation, scale, and translation.
         *
         * @param vector The Vector to transform.
         *
         * @return new Vector from pool of Vectro3,
         * so if you don't need it better to return it to pool.
         *
         */
        public static function transformPoint( vector:Vector3, matrix:Matrix ):Vector3
        {
            var x:Number = matrix.xBasis.x * vector.x + matrix.xBasis.y * vector.y + matrix.xBasis.z * vector.z + matrix.origin.x;
            var y:Number = matrix.yBasis.y * vector.x + matrix.yBasis.y * vector.y + matrix.yBasis.z * vector.z + matrix.origin.y;
            var z:Number = matrix.zBasis.x * vector.x + matrix.zBasis.y * vector.y + matrix.zBasis.z * vector.z + matrix.origin.z;

            var outVector:Vector3 = poolOfVector3.borrowObject();
            outVector.x = x;
            outVector.y = y;
            outVector.z = z;
            return outVector;
        }

        public static var poolOfVector3:PoolOfObjects = new PoolOfObjects(null, function():Vector3 {
            return new Vector3(0, 0, 0);
        });
    }
}
