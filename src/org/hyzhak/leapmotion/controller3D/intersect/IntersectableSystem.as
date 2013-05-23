package org.hyzhak.leapmotion.controller3D.intersect {
    import com.leapmotion.leap.Matrix;
    import com.leapmotion.leap.Vector3;

    public class IntersectableSystem {
        public var transformation:Matrix = Matrix.identity();
        private var _targets:Vector.<IIntersectable> = new <IIntersectable>[];

        public function addChild(value:IIntersectable):void {
            _targets.push(value);
        }

        public function getChildAt(vector:Vector3):IIntersectable {
            for each(var child:IIntersectable in _targets) {
                if (child.isIntersect(vector.x, -vector.z, vector.y)) {
                    return child;
                }
            }

            return null;
        }
    }
}
