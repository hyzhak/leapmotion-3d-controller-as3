package org.hyzhak.leapmotion.controller3D.fingers {
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.events.Event3D;

    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Matrix;
    import com.leapmotion.leap.Pointable;
    import com.leapmotion.leap.Vector3;
    import com.leapmotion.leap.events.LeapEvent;

    import flash.display.Stage3D;

    import org.hyzhak.leapmotion.controller3D.alternativa3d.Alternativa3DStageBuilder;

    import org.hyzhak.utils.MatrixUtil;

    /**
     * TODO: Remove Alternativa3D dependency
     */
    public class LeapMotionFingersView extends Object3D {
        public var transformation:Matrix = Matrix.identity();

        private var _controller:Controller;

        private var _fingersPool:PointablesPool = new PointablesPool(ArrowFingerView);
        private var _toolsPool:PointablesPool = new PointablesPool(ToolFingerView);

        private var _fingers:Vector.<AbstractFingerView> = new <AbstractFingerView>[];
        private var _tools:Vector.<AbstractFingerView> = new <AbstractFingerView>[];

        public function set withStage3D(value:Stage3D):void {
            _fingersPool.stage3D = value;
            _toolsPool.stage3D = value;
        }

        public function set controller(value:Controller):void {
            _controller = value;
        }

        public function build(scene:Alternativa3DStageBuilder):void {
            addEventListener(Event3D.ADDED, onAdded);
            addEventListener(Event3D.REMOVED, onRemoved);

            scene.rootContainer.addChild(this);
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
            markPointablesAsUnprocessed(_fingers);
            markPointablesAsUnprocessed(_tools);

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
                view.unprocessed = false;

                var vec:Vector3 = MatrixUtil.transformPoint(pointable.tipPosition, transformation);
                view.x = vec.x;
                view.y = vec.y;
                view.z = vec.z;
                MatrixUtil.poolOfVector3.returnObject(vec);

                vec = MatrixUtil.transformPoint(pointable.direction, transformation);
                view.rotationX = vec.pitch;
                view.rotationZ = vec.roll + Math.PI;
                MatrixUtil.poolOfVector3.returnObject(vec);
            }

            sweepUnprocessedPointables(_fingers, _fingersPool);
            sweepUnprocessedPointables(_tools, _toolsPool);
        }

        private function markPointablesAsUnprocessed(collection:Vector.<AbstractFingerView>):void {
            for each(var finger:AbstractFingerView in collection) {
                if (finger) {
                    finger.unprocessed = true;
                }
            }
        }

        private function sweepUnprocessedPointables(collection:Vector.<AbstractFingerView>, pool:PointablesPool):void {
            for(var i:int = 0, count:int = collection.length; i < count; i++) {
                var finger:AbstractFingerView = collection[i];
                if (finger && finger.unprocessed) {
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