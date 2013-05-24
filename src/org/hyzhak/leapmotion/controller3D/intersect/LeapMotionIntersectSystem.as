package org.hyzhak.leapmotion.controller3D.intersect {
    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Frame;
    import com.leapmotion.leap.Pointable;
    import com.leapmotion.leap.events.LeapEvent;

    import flash.events.EventDispatcher;

    import org.hyzhak.leapmotion.controller3D.PoolOfObjects;

    [Event(name="hover", type="org.hyzhak.leapmotion.controller3D.intersect.IntersectEvent")]
    [Event(name="unhover", type="org.hyzhak.leapmotion.controller3D.intersect.IntersectEvent")]
    public class LeapMotionIntersectSystem extends EventDispatcher {
        //The timestamp in microseconds.
        public var microsecondToHover:int = 0;

        public var intersectables:IntersectableSystem = new IntersectableSystem();

        private var _poolPointableIntersection:PoolOfObjects = new PoolOfObjects(Intersection);

        private var _controller:Controller;
        private var _childUnderFinger:Vector.<Intersection> = new <Intersection>[];
        private var _previousTime:Number;

        public function LeapMotionIntersectSystem(controller:Controller) {
            _controller = controller;
            _controller.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
        }

        private function onFrame(event:LeapEvent):void {
            markAsUnprocessed();
            processFrame(event.frame);
            swipeUnprocessed();
        }

        private function processFrame(frame:Frame):void {
            var currentTime:Number = frame.timestamp;
            var deltaTime:Number;
            if (_previousTime > 0) {
                deltaTime = currentTime - _previousTime;
            }
            _previousTime = currentTime;

            var pointables:Vector.<Pointable> = frame.pointables;
            for(var i:int = 0, count:int = pointables.length; i < count; i++) {
                var pointable:Pointable = pointables[i];

                var intersectable:IIntersectable = intersectables.getChildAt(pointable.tipPosition);

                var intersection:Intersection;
                if ( i < _childUnderFinger.length) {
                    intersection = _childUnderFinger[i];
                }
                if (intersection && intersection.intersectable == intersectable) {
                    intersection.duration += deltaTime;
                    intersection.unprocessed = false;
                    if (intersection.duration >= microsecondToHover) {
                        hover(intersection);
                    }
                } else {
                    if (intersection) {
                        unhover(intersection, i);
                    }

                    if (intersectable) {
                        intersection = _poolPointableIntersection.borrowObject();
                        intersection.unprocessed = false;
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

        private function markAsUnprocessed():void {
            for(var i:int = 0, count:int = _childUnderFinger.length; i < count; i++) {
                var intersection:Intersection = _childUnderFinger[i];
                if (intersection) {
                    intersection.unprocessed = true
                }
            }
        }

        private function swipeUnprocessed():void {
            for(var i:int = 0, count:int = _childUnderFinger.length; i < count; i++) {
                var intersection:Intersection = _childUnderFinger[i];
                if (intersection && intersection.unprocessed) {
                    unhover(_childUnderFinger[i], i);
                }
            }
        }

        private function hover(intersection:Intersection):void {
            if (!intersection.intersectable.hovered) {
                dispatchEvent(new IntersectEvent(IntersectEvent.HOVER, intersection.intersectable));
            }
            intersection.intersectable.hovered = true;
        }

        private function unhover(intersection:Intersection, index:int):void {
            if (intersection == null) {
                return;
            }

            if (intersection.intersectable.hovered) {
                dispatchEvent(new IntersectEvent(IntersectEvent.UNHOVER, intersection.intersectable));
            }

            intersection.intersectable.hovered = false;
            _childUnderFinger[index] = null;
            _poolPointableIntersection.returnObject(intersection);
        }
    }
}

import org.hyzhak.leapmotion.controller3D.intersect.IIntersectable;

internal class Intersection {
    public var intersectable:IIntersectable;
    public var duration:int;
    public var unprocessed:Boolean;
}