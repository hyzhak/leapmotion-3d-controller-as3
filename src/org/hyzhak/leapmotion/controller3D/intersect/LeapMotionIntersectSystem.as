package org.hyzhak.leapmotion.controller3D.intersect {
    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Pointable;
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
                        intersection.hover = true;
                    }

                    if (intersection.duration >= msecToSelect) {
                        intersection.selected = true;
                    }
                } else {
                    if (intersection) {
                        intersection.hover = false;
                        intersection.selected = false;
                        _childUnderFinger[i] = null;
                        _poolPointableIntersection.returnObject(intersection);
                    }

                    if (intersectable) {
                        intersection = _poolPointableIntersection.borrowObject();
                        intersection.selected = false;
                        intersection.intersectable = intersectable;
                        intersection.duration = 0;
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

    private var _hover:Boolean;
    private var _selected:Boolean;

    public function get hover():Boolean {
        return _hover;
    }

    public function set hover(value:Boolean):void {
        if (_hover == value) {
            return;
        }

        _hover = value;

        if (value) {
            intersectable.hover();
        } else {
            intersectable.unhover();
        }
    }

    public function get selected():Boolean {
        return _selected;
    }

    public function set selected(value:Boolean):void {
        if (_selected == value) {
            return;
        }

        _selected = value;
        if (value) {
            intersectable.select();
        } else {
            intersectable.unselect();
        }
    }
}