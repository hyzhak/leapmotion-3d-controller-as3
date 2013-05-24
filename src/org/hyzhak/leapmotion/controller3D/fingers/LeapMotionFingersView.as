package org.hyzhak.leapmotion.controller3D.fingers {
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.events.Event3D;

    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Finger;
    import com.leapmotion.leap.Matrix;
    import com.leapmotion.leap.Pointable;
    import com.leapmotion.leap.Vector3;
    import com.leapmotion.leap.events.LeapEvent;
    import com.leapmotion.leap.util.LeapUtil;

    import flash.display.Stage3D;

    import flash.utils.setTimeout;

    import org.hyzhak.leapmotion.controller3D.LeapMotionDemo;
    import org.hyzhak.leapmotion.controller3D.MatrixUtil;

    import org.hyzhak.leapmotion.controller3D.fingers.AbstractFingerView;

    public class LeapMotionFingersView extends Object3D {
        public var transformation:Matrix = Matrix.identity();

        private var _controller:Controller;

        private var _fingersPool:PointablesPool = new PointablesPool(ArrowFingerView);
        private var _toolsPool:PointablesPool = new PointablesPool(ToolFingerView);

        private var _fingers:Vector.<AbstractFingerView> = new <AbstractFingerView>[];
        private var _tools:Vector.<AbstractFingerView> = new <AbstractFingerView>[];

        public function LeapMotionFingersView(controller:Controller) {
            super();

            _controller = controller;

            addEventListener(Event3D.ADDED, onAdded);
            addEventListener(Event3D.REMOVED, onRemoved);
        }

        public function set withStage3D(value:Stage3D):void {
            _fingersPool.stage3D = value;
            _toolsPool.stage3D = value;
        }

        private function onAdded(event:Event3D):void {
            if (event.target != this) {
                return;
            }
            _controller.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
        }

        private function onRemoved(event:Event3D):void {
            if (event.target != this) {
                return;
            }

            _controller.removeEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
        }

        private function onFrame(event:LeapEvent):void {
            markFingersAsUseless(_fingers);
            markFingersAsUseless(_tools);

            var fingers:Vector.<Pointable> = event.frame.pointables;
            for each(var pointable:Pointable in fingers) {
                var view:AbstractFingerView;
                if (pointable.isFinger) {
                    view = getFingerViewById(pointable.id);
                } else if (pointable.isTool){
                    view = getToolViewById(pointable.id);
                } else {
                    throw new Error("Undefined pointable! Need to implement view for it.");
                }
                view.useless = false;

                var tipPosition:Vector3 = MatrixUtil.transformPoint(pointable.tipPosition, transformation);
                //var tipPosition:Vector3 = transformation.transformPoint(pointable.tipPosition);
                view.x = tipPosition.x;
                view.y = tipPosition.y;
                view.z = tipPosition.z;

                MatrixUtil.poolOfVector3.returnObject(tipPosition);

                //view.x = scale * tipPosition.x;
                //view.y = -scale * tipPosition.z;
                //view.z = scale * tipPosition.y;

//                view.scaleY = pointable.length;
                view.rotationX = Math.PI / 2 + pointable.direction.pitch;
                view.rotationZ = -pointable.direction.yaw;//Math.PI / 2;
                //view.rotationZ = Math.PI / 2;
                //view.rotationZ = pointable.direction.yaw;
//                view.rotationZ = finger.direction.roll;
            }

            sweepUnusedFingers(_fingers, _fingersPool);
            sweepUnusedFingers(_tools, _toolsPool);
        }

        private function markFingersAsUseless(collection:Vector.<AbstractFingerView>):void {
            for each(var finger:AbstractFingerView in collection) {
                if (finger) {
                    finger.useless = true;
                }
            }
        }

        private function sweepUnusedFingers(collection:Vector.<AbstractFingerView>, pool:PointablesPool):void {
            for(var i:int = 0, count:int = collection.length; i < count; i++) {
                var finger:AbstractFingerView = collection[i];
                if (finger && finger.useless) {
                    pool.returnObject(finger);
                    removeChild(finger);
                    collection[i] = null;
                }
            }
        }

        private function getFingerViewById(id:int):AbstractFingerView {
            return getPointableById(_fingersPool, _fingers, id);
        }

        private function getToolViewById(id:int):AbstractFingerView {
            return getPointableById(_toolsPool, _tools, id);
        }

        private function getPointableById(pool:PointablesPool, fingersCollection:Vector.<AbstractFingerView>, id:int):AbstractFingerView {
            var fingerView:AbstractFingerView;
            if (id < fingersCollection.length) {
                fingerView = fingersCollection[id];
            }
            if (fingerView) {
                return fingerView;
            }

            fingerView = pool.borrowObject();
            addChild(fingerView);
            if (fingersCollection.length <= id) {
                fingersCollection.length = id + 1;
            }

            fingersCollection[id] = fingerView;
            return fingerView;
        }
    }
}