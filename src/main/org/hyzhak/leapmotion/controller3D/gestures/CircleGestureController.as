package org.hyzhak.leapmotion.controller3D.gestures {
    import org.hyzhak.leapmotion.controller3D.*;
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.CircleGesture;
    import com.leapmotion.leap.Gesture;

    public class CircleGestureController implements IGestureController{
        public var rotationMultiplier:Number = 0.5;
        public var rotationAcceleration:Number = 0.1;
        public var rotationDegradation:Number = 0.9;

        private var _applying:Boolean;
        private var _rotationClockwise:Boolean;
        private var _beginProgress:Number = 0;
        private var _endProgress:Number = 0;

        private var _rotationSpeed:Number = 0;

        public function applyTo(object:Object3D):void {
            if (_applying) {
                if (_rotationClockwise) {
                    _rotationSpeed +=  rotationAcceleration * (_endProgress - _beginProgress - _rotationSpeed);
                } else {
                    _rotationSpeed +=  rotationAcceleration * (- _endProgress + _beginProgress - _rotationSpeed);
                }
                _beginProgress = _endProgress;
            } else {
                _rotationSpeed *= rotationDegradation;
            }

            object.rotationY += 2 * Math.PI * rotationMultiplier * _rotationSpeed;
        }

        public function updateWith(gesture:Gesture):void {
            var circleGesture:CircleGesture = gesture as CircleGesture;
            switch(circleGesture.state) {
                case Gesture.STATE_START:
                    _applying = true;
                    _endProgress = _beginProgress = circleGesture.progress;
                    _rotationClockwise = circleGesture.pointable.direction.angleTo(circleGesture.normal) <= Math.PI/4;
                    break;
                case Gesture.STATE_UPDATE:
                    _endProgress = circleGesture.progress;
                    break;
                case Gesture.STATE_STOP:
                    _applying = false;
                    break;
            }
        }
    }
}
