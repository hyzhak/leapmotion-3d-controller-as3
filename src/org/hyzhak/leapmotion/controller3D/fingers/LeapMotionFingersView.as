package org.hyzhak.leapmotion.controller3D.fingers {
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.events.Event3D;

    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Finger;
    import com.leapmotion.leap.Vector3;
    import com.leapmotion.leap.events.LeapEvent;

    import org.hyzhak.leapmotion.controller3D.fingers.AbstractFingerView;

    public class LeapMotionFingersView extends Object3D {
        public var scale:Number = 1.0;

        private var _controller:Controller;

        public var fingersPool:FingersPool = new FingersPool(ArrowFingerView);

        private var _fingers:Vector.<AbstractFingerView> = new <AbstractFingerView>[];

        public function LeapMotionFingersView(controller:Controller) {
            super();

            _controller = controller;

            addEventListener(Event3D.ADDED, onAdded);
            addEventListener(Event3D.REMOVED, onRemoved);
        }

        private function onAdded(event:Event3D):void {
            _controller.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
        }

        private function onRemoved(event:Event3D):void {
            _controller.removeEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
        }

        private function onFrame(event:LeapEvent):void {
            clearMarkOfUsage();

            var fingers:Vector.<Finger> = event.frame.fingers;
            for each(var finger:Finger in fingers) {
                var view:AbstractFingerView = getFingerViewById(finger.id);
                view.used = true;
                var tipPosition:Vector3 = finger.tipPosition;
                view.x = scale * tipPosition.x;
                view.y = scale * tipPosition.y;
                view.z = scale * tipPosition.z;
                //view.scaleX = finger.length;
//                view.rotationX = finger.direction.pitch;
//                view.rotationY = finger.direction.yaw;
//                view.rotationZ = finger.direction.roll;
            }

            disposeUnusedFingers();
        }

        private function disposeUnusedFingers():void {
            for(var i:int = 0, count:int = _fingers.length; i < count; i++) {
                var finger:AbstractFingerView = _fingers[i];
                if (!finger.used) {
                    fingersPool.returnObject(finger);
                    removeChild(finger);
                    _fingers[i] = null;
                }
            }
        }

        private function clearMarkOfUsage():void {
            for each(var finger:AbstractFingerView in _fingers) {
                finger.used = false;
            }
        }

        private function getFingerViewById(id:int):AbstractFingerView {
            var fingerView:AbstractFingerView;
            if (id < _fingers.length) {
                fingerView = _fingers[id];
            }
            if (fingerView) {
                return fingerView;
            }

            fingerView = fingersPool.borrowObject();
            addChild(fingerView);
            return fingerView;
        }
    }
}