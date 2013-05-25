package org.hyzhak.leapmotion.controller3D.intersect {
    import com.leapmotion.leap.Matrix;
    import com.leapmotion.leap.Vector3;

    /**
     * TODO : We can use more optimal ways to find intersection (KDThree)     *
     */
    public class BruteForceIntersectableSystem {
        private var _targets:Vector.<IIntersectable> = new <IIntersectable>[];

        public function addChild(value:IIntersectable):void {
            _targets.push(value);
        }

        public function getChildAt(vector:Vector3):IIntersectable {
            for each(var child:IIntersectable in _targets) {
                if (child.isIntersect(vector.x, vector.y, vector.z)) {
                    return child;
                }
            }

            return null;
        }
    }
}
