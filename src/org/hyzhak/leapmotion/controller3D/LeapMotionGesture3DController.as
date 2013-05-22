package org.hyzhak.leapmotion.controller3D {
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.CircleGesture;
    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Frame;
    import com.leapmotion.leap.Gesture;
    import com.leapmotion.leap.events.LeapEvent;

    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.events.Event;

    public class LeapMotionGesture3DController {
        private var _object:Object3D;
        private var _controller:Controller;

        private var _circleGestureController:CircleGestureController;

        public function LeapMotionGesture3DController(eventSource:InteractiveObject, object:Object3D, controller: Controller, debugDrawView:Sprite = null) {
            _object = object;

            _circleGestureController = new CircleGestureController();

            _controller = controller;
            _controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
            eventSource.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:Event):void {
            _circleGestureController.applyTo(_object);
        }

        private function onFrame(event:LeapEvent):void {
            // Get the most recent frame and report some basic information
            var frame:Frame = event.frame;
            var gestures:Vector.<Gesture> = frame.gestures();

            var circles:int = 0;
            for each(var gesture:Gesture in gestures) {
                switch (gesture.type) {
                    case Gesture.TYPE_CIRCLE:
                        circles++;
                        _circleGestureController.updateWith(gesture as CircleGesture);
                        break;
                }
            }
        }
    }
}
