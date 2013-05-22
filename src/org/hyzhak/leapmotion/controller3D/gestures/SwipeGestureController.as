package org.hyzhak.leapmotion.controller3D.gestures {
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.Gesture;
    import com.leapmotion.leap.SwipeGesture;
    import com.leapmotion.leap.Vector3;

    import org.hyzhak.leapmotion.controller3D.IGestureController;

    public class SwipeGestureController implements IGestureController {
        public var rotationMultiplier:Number = 0.0001;

        private var count:int = 0;
        private var speed:int = 0;

        private var direction:Vector3;

        private var _applying:Boolean;

        public function applyTo(object:Object3D):void {
            if (_applying) {
                trace("count: ", count);
                trace("speed: ", speed);
                trace("direction", direction);
                count = 0;
                if (direction.x > 0) {
                    object.rotationZ+= rotationMultiplier * speed;
                } else {
                    object.rotationZ-= rotationMultiplier * speed;
                }
                speed = 0;
            }
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
            count++;
            var swipe:SwipeGesture = gesture as SwipeGesture;
            speed += swipe.speed;
            direction = swipe.direction;
        }
    }
}
