package org.hyzhak.leapmotion.controller3D {
    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Gesture;
    import com.leapmotion.leap.Matrix;
    import com.leapmotion.leap.Vector3;
    import com.leapmotion.leap.events.LeapEvent;

    public class LeapMotionSystem {
        public var transformation:Matrix;

        private var _controller:Controller;

        public function LeapMotionSystem() {
            transformation = Matrix.identity();
            transformation.setRotation(new Vector3(1, 0, 0), Math.PI / 2);

            _controller = new Controller();

            _controller.addEventListener( LeapEvent.LEAPMOTION_INIT, onInit );
            _controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, onConnect );
            _controller.addEventListener( LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect );
            _controller.addEventListener( LeapEvent.LEAPMOTION_EXIT, onExit );
//            _controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
        }

        public function get controller():Controller {
            return _controller;
        }

        private function onInit(event:LeapEvent):void {
            trace("onInit");
        }

        private function onConnect(event:LeapEvent):void {
            trace("onConnect");
            _controller.enableGesture(Gesture.TYPE_CIRCLE);
            _controller.enableGesture(Gesture.TYPE_SWIPE );
            _controller.enableGesture(Gesture.TYPE_SCREEN_TAP);
        }

        private function onDisconnect(event:LeapEvent):void {
            trace("onDisconnect");
        }

        private function onExit(event:LeapEvent):void {
            trace("onExit");
        }
    }
}
