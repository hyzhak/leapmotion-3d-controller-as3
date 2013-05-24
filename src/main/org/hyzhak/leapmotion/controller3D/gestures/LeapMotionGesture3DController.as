package org.hyzhak.leapmotion.controller3D.gestures {
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Frame;
    import com.leapmotion.leap.Gesture;
    import com.leapmotion.leap.Matrix;
    import com.leapmotion.leap.Vector3;
    import com.leapmotion.leap.events.LeapEvent;

    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.events.Event;

    public class LeapMotionGesture3DController {

        private var leapMotionTransformation:Matrix;
        private var _object:Object3D;
        private var _controller:Controller;

        private var _gestureControllers:Object = {};

        public function LeapMotionGesture3DController(eventSource:InteractiveObject, object:Object3D, controller: Controller, debugDrawView:Sprite = null) {
            leapMotionTransformation = Matrix.identity();
            leapMotionTransformation.setRotation(new Vector3(1, 0, 0), Math.PI / 2);

            _object = object;

            _gestureControllers[Gesture.TYPE_CIRCLE] = [
                new CircleGestureController()
            ];

            _gestureControllers[Gesture.TYPE_SWIPE] = [
                new SwipeGestureController(),
                new TraceGestureController("swipe")
            ];

            _controller = controller;
            _controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
            eventSource.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:Event):void {
            for each(var controllers:Array in _gestureControllers) {
                for each(var controller:IGestureController in controllers) {
                    controller.applyTo(_object);
                }
            }
        }

        private function onFrame(event:LeapEvent):void {
            var frame:Frame = event.frame;
            var gestures:Vector.<Gesture> = frame.gestures();
            for each(var gesture:Gesture in gestures) {
                var controllers:Array = _gestureControllers[gesture.type];
                for each(var controller:IGestureController in controllers) {
                    controller.updateWith(gesture);
                }
            }
        }
    }
}
