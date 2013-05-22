package org.hyzhak.leapmotion.controller3D {
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Frame;
    import com.leapmotion.leap.Gesture;
    import com.leapmotion.leap.events.LeapEvent;

    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.events.Event;

    import org.hyzhak.leapmotion.controller3D.gestures.CircleGestureController;
    import org.hyzhak.leapmotion.controller3D.gestures.SwipeGestureController;

    public class LeapMotionGesture3DController {
        private var _object:Object3D;
        private var _controller:Controller;

        private var _gestureControllers:Object = {};

        public function LeapMotionGesture3DController(eventSource:InteractiveObject, object:Object3D, controller: Controller, debugDrawView:Sprite = null) {
            _object = object;

            _gestureControllers[Gesture.TYPE_CIRCLE] = new CircleGestureController();
            _gestureControllers[Gesture.TYPE_SWIPE] = new SwipeGestureController();

            _controller = controller;
            _controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
            eventSource.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:Event):void {
            for each(var controller:IGestureController in _gestureControllers) {
                controller.applyTo(_object);
            }
        }

        private function onFrame(event:LeapEvent):void {
            var frame:Frame = event.frame;
            var gestures:Vector.<Gesture> = frame.gestures();
            for each(var gesture:Gesture in gestures) {
                var controller:IGestureController = _gestureControllers[gesture.type];
                if (controller) {
                    controller.updateWith(gesture);
                }
            }
        }
    }
}
