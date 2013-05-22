package org.hyzhak.leapmotion.controller3D.gestures {
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.Gesture;
    import com.leapmotion.leap.SwipeGesture;
    import com.leapmotion.leap.Vector3;

    import org.hyzhak.leapmotion.controller3D.IGestureController;

    public class SwipeGestureController implements IGestureController {
        public var rotationMultiplier:Number = 0.0003;
        public var rotationAcceleration:Number = 0.1;
        public var rotationDegradation:Number = 0.9;

        private var _speed:int = 0;
        private var _swipeSpeed:int = 0;

        private var _direction:Vector3;

        private var _applying:Boolean;

        public function applyTo(object:Object3D):void {
            if (_applying) {
                if (_direction.x > 0) {
                    _speed += rotationAcceleration*(_swipeSpeed - _speed)
                } else {
                    _speed += rotationAcceleration*(-_swipeSpeed - _speed)
                }
                _swipeSpeed = 0;
            } else {
                _speed*=rotationDegradation;
            }

            object.rotationZ += rotationMultiplier * _speed;
        }

        public function updateWith(gesture:Gesture):void {
            switch (gesture.state) {
                case Gesture.STATE_START:
                    _applying = true;
                    break;
                case Gesture.STATE_STOP:
                    _applying = false;
                    break;
            }

            var swipe:SwipeGesture = gesture as SwipeGesture;
            _swipeSpeed += swipe.speed;
            _direction = swipe.direction;
        }
    }
}
