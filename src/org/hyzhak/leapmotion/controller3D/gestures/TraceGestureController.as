package org.hyzhak.leapmotion.controller3D.gestures {
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.Gesture;

    import org.hyzhak.leapmotion.controller3D.IGestureController;

    public class TraceGestureController implements IGestureController {
        private var _count:int = 0;
        private var _duration:Number = 0.0;
        private var _applying:Boolean;
        private var _name:String;

        public function TraceGestureController(name:String) {
            _name = name;
        }

        public function applyTo(object:Object3D):void {
            if (_applying) {
                trace(_name, "update count:", _count, "durationn:", _duration);
                _count = 0;
                _duration = 0;
            }
        }

        public function updateWith(gesture:Gesture):void {
            switch (gesture.state) {
                case Gesture.STATE_START:
                    _applying = true;
                    break;
                case Gesture.STATE_UPDATE:
                    _count++;
                    _duration+=gesture.durationSeconds;
                    break;
                case Gesture.STATE_STOP:
                    _applying = false;
                    break;
            }
        }
    }
}
