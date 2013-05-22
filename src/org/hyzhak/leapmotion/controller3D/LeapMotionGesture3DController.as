package org.hyzhak.leapmotion.controller3D {
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.CircleGesture;

    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Finger;
    import com.leapmotion.leap.Frame;
    import com.leapmotion.leap.Gesture;
    import com.leapmotion.leap.Vector3;
    import com.leapmotion.leap.events.LeapEvent;

    import flash.display.InteractiveObject;

    import flash.display.Sprite;
    import flash.events.Event;

    public class LeapMotionGesture3DController {
        private var _object:Object3D;
        private var _controller:Controller;


        private var _circleGestureInProgress:Boolean;
        private var _rotationClockwise:Boolean;
        private var _rotationMultiplier:Number = 1.0;
        private var _startProgress:Number = 0;
        private var _startRotation:Number = 0;
        private var _rotationSpeed:Number = 0;
        private var _rotationAccel:Number = 0.03;
        private var _rotationDegrade:Number = 0.75;

        private var _lookAt:Vector3 = new Vector3(0, 0, -1);

        public function LeapMotionGesture3DController(eventSource:InteractiveObject, object:Object3D, controller: Controller, debugDrawView:Sprite = null) {
            _object = object;
            _controller = controller;
            _controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
            eventSource.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:Event):void {
            var delta:Number = 2 * Math.PI * _rotationMultiplier * _rotationSpeed;
            if (_rotationClockwise) {
                _object.rotationY += delta;
            } else {
                _object.rotationY -= delta;
            }

            if (!_circleGestureInProgress) {
                _rotationSpeed*=_rotationDegrade;
            }
        }

        private function onFrame(event:LeapEvent):void {
            // Get the most recent frame and report some basic information
            var frame:Frame = event.frame;
            var gestures:Vector.<Gesture> = frame.gestures();

            var degradeRotation:Boolean = true;
            for each(var gesture:Gesture in gestures) {
                switch (gesture.type) {
                    case Gesture.TYPE_CIRCLE:
                        degradeRotation = false;

                        var circleGesture:CircleGesture = gesture as CircleGesture;
                        switch(circleGesture.state) {
                            case Gesture.STATE_START:
                                _circleGestureInProgress = true;
                                _startProgress = circleGesture.progress;
                                _startRotation = _object.rotationY;
                                _rotationSpeed = 0;
                                _rotationClockwise = circleGesture.pointable.direction.angleTo(circleGesture.normal) <= Math.PI/4;
                                break;
                            case Gesture.STATE_UPDATE:
                                _rotationSpeed += _rotationAccel * (circleGesture.progress - _startProgress - _rotationSpeed);
                                _startProgress = circleGesture.progress;
                                break;
                            case Gesture.STATE_STOP:
                                _circleGestureInProgress = false;
                                break;
                        }
                        break;
                }
            }
        }
    }
}
