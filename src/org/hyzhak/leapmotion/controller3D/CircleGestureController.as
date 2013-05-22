package org.hyzhak.leapmotion.controller3D {
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.CircleGesture;
    import com.leapmotion.leap.Gesture;

    public class CircleGestureController {

        private var _applying:Boolean;
        private var _rotationClockwise:Boolean;

        private var _rotationMultiplier:Number = 0.5;

        private var _beginProgress:Number = 0;
        private var _endProgress:Number = 0;

        private var _rotationSpeed:Number = 0;

        private var _rotationAcceleration:Number = 0.1;
        private var _rotationDegradation:Number = 0.9;

        public function applyTo(object:Object3D):void {
            if (_applying) {
                if (_rotationClockwise) {
                    _rotationSpeed +=  _rotationAcceleration * (_endProgress - _beginProgress - _rotationSpeed);
                } else {
                    _rotationSpeed +=  _rotationAcceleration * (- _endProgress + _beginProgress - _rotationSpeed);
                }
                _beginProgress = _endProgress;
            } else {
                _rotationSpeed *= _rotationDegradation;
            }

            object.rotationY += 2 * Math.PI * _rotationMultiplier * _rotationSpeed;
        }

        public function updateWith(circleGesture:CircleGesture):void {
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
