package org.hyzhak.leapmotion.controller3D.dragndrop {
    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Frame;
    import com.leapmotion.leap.Matrix;
    import com.leapmotion.leap.Pointable;
    import com.leapmotion.leap.Vector3;
    import com.leapmotion.leap.events.LeapEvent;

    import flash.utils.Dictionary;

    import org.hyzhak.utils.MatrixUtil;
    import org.hyzhak.utils.PoolOfObjects;
    import org.hyzhak.leapmotion.controller3D.intersect.IIntersectable;

    public class DragNDropController {
        public var transformation:Matrix = Matrix.identity();

        public var controller:Controller;

        public var intersectable:IIntersectable;

        private var _poolOfPointablePosition:PoolOfObjects = new PoolOfObjects(PointablePosition);
        private var _previousPosition:Vector.<PointablePosition> = new <PointablePosition>[];

        public function start():void {
            controller.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
            intersectable.select();
        }

        public function stop():void {
            controller.removeEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
            intersectable.unselect();
        }

        private function onFrame(event:LeapEvent):void {
            markAsUnprocessed();
            processFrame(event.frame);
            sweepUnprocessed();
        }

        private function markAsUnprocessed():void {
            for each(var pointablePosition:PointablePosition in _previousPosition) {
                if (pointablePosition) {
                    pointablePosition.unprocessed = true;
                }
            }
        }

        private function sweepUnprocessed():void {
            for (var i:int = 0, count:int = _previousPosition.length; i < count; i++) {
                var pointablePosition:PointablePosition = _previousPosition[i];
                if (pointablePosition && pointablePosition.unprocessed) {
                    _poolOfPointablePosition.returnObject(pointablePosition);
                    _previousPosition[i] = null;
                }
            }
        }

        private function processFrame(frame:Frame):void {
            var usedPointables:Dictionary = intersectable.pointables.collection;
            var dx:Number = 0;
            var dy:Number = 0;
            var dz:Number = 0;
            for(var id:Object in usedPointables) {
                var pointable:Pointable = frame.pointable(id as int);

                //0. transpose coordinates
                var position:Vector3 = MatrixUtil.transformPoint(pointable.tipPosition, transformation);

                //1. get start position
                if (_previousPosition.length <= id) {
                    _previousPosition.length = id + 1;
                }

                var pointablePosition:PointablePosition = _previousPosition[id];
                if (pointablePosition == null) {
                    pointablePosition = _poolOfPointablePosition.borrowObject();
                    pointablePosition.position = position;
                    _previousPosition[id] = pointablePosition;
                } else {
                    //2. calc relevant position
                    dx += position.x - pointablePosition.position.x;
                    dy += position.y - pointablePosition.position.y;
                    dz += position.z - pointablePosition.position.z;
                    MatrixUtil.poolOfVector3.returnObject(pointablePosition.position);
                    pointablePosition.position = position;
                }
                pointablePosition.unprocessed = false;
            }

            if (intersectable.pointables.size() > 0) {
                //3. use average position
                var coef:Number = 1 / intersectable.pointables.size();
                dx *= coef;
                dy *= coef;
                dz *= coef;

                //TODO : 4. calc rotation and scale
                //...

                //5. apply position
                if (isNaN(dx)) {
                    throw new Error();
                }

                intersectable.shift(dx, dy, dz);
            }
        }
    }
}

import com.leapmotion.leap.Vector3;

class PointablePosition {
    public var position:Vector3;
    public var unprocessed:Boolean;
}