package org.hyzhak.leapmotion.controller3D.intersect {
    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Pointable;
    import com.leapmotion.leap.events.LeapEvent;

    import org.hyzhak.leapmotion.controller3D.PoolOfObjects;

    public class LeapMotionIntersectSystem {
        public var msecToHover:int = 0;
        public var msecToSelect:int = 1000;
        //public var msecToUnSelect:int = 100;

        public var intersectables:IntersectableSystem = new IntersectableSystem();

        private var _poolPointableIntersection:PoolOfObjects = new PoolOfObjects(PointableIntersection);
        private var _controller:Controller;
        private var _childUnderFinger:Vector.<PointableIntersection> = new <PointableIntersection>[];
        private var _previousTime:int;

        public function LeapMotionIntersectSystem(controller:Controller) {
            _controller = controller;
            _controller.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
        }

        private function onFrame(event:LeapEvent):void {
            var currentTime:int = event.frame.timestamp
            var deltaTime:int;
            if (_previousTime > 0) {
                deltaTime = currentTime - _previousTime;
            }
            _previousTime = currentTime;
            var pointables:Vector.<Pointable> = event.frame.pointables;
            for(var i:int = 0, count:int = pointables.length; i < count; i++) {
                var pointable:Pointable = pointables[i];

                var intersectable:IIntersectable = intersectables.getChildAt(pointable.tipPosition);

                var intersection:PointableIntersection;
                if ( i < _childUnderFinger.length) {
                    intersection = _childUnderFinger[i];
                }
                if (intersection && intersection.intersectable == intersectable) {
                    intersection.duration += deltaTime;
                    if (intersection.duration >= msecToHover) {
                        intersection.intersectable.hovered = true;
                    }

                    if (intersection.duration >= msecToSelect) {
                        intersection.intersectable.selected = true;
                    }
                } else {
                    if (intersection) {
                        intersection.intersectable.hovered = false;
                        intersection.intersectable.selected = false;
                        _childUnderFinger[i] = null;
                        _poolPointableIntersection.returnObject(intersection);
                    }

                    if (intersectable) {
                        intersection = _poolPointableIntersection.borrowObject();
                        intersection.intersectable = intersectable;
                        intersection.duration = 0;
                        if (_childUnderFinger.length <= i) {
                            _childUnderFinger.length = i + 1;
                        }
                        _childUnderFinger[i] = intersection;
                    }
                }
            }
        }
    }
}

import org.hyzhak.leapmotion.controller3D.intersect.IIntersectable;

internal class PointableIntersection {
    public var intersectable:IIntersectable;
    public var duration:int;
}