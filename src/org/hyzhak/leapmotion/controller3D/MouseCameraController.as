package org.hyzhak.leapmotion.controller3D {
    import alternativa.engine3d.alternativa3d;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.primitives.Plane;

    import flash.display.InteractiveObject;

    import flash.display.Sprite;

    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;

    use namespace alternativa3d;

	public class MouseCameraController extends Object3D {

		// config
		// private var _stepRotateKey:Number = 0.3;
		// view parameters
		private var _oldX : Number;

		private var _oldY : Number;

		private var _oldRZ : Number;

		private var _oldRX : Number;

        private var _eventSource:InteractiveObject;

		private var _object : Object3D;

		private var _stage : Stage;

		private var isLeftCamera : int = 1;

		public function MouseCameraController(object : Object3D, eventSource:InteractiveObject, stage : Stage) {
			_object = object;
			_stage = stage;
            _eventSource = eventSource;
			initInstance();
		}

		public function initInstance() : void {
			addChild(_object);

            if (_object is Camera3D) {
                _object.rotationX = -Math.PI / 2;
            }

            _eventSource.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            _eventSource.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		private function onMouseDown(event : MouseEvent) : void {
			_oldX = _stage.mouseX;
			_oldY = _stage.mouseY;
			_oldRX = rotationX;
			_oldRZ = rotationZ;
			_stage.addEventListener(MouseEvent.MOUSE_UP, goMouseUp);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, goMouseMove);
		}

		private function goMouseMove(event : MouseEvent) : void {
			var factor : Number = 200;
			var newRz : Number = _oldRZ + isLeftCamera * (_oldX - _stage.mouseX) / factor;
			var newRx : Number = _oldRX + isLeftCamera * (_oldY - _stage.mouseY) / factor;

			rotationX = newRx;
			rotationZ = newRz;
		}

		private function goMouseUp(event : MouseEvent) : void {
			_oldX = _stage.mouseX;
			_oldY = _stage.mouseY;
			_stage.removeEventListener(MouseEvent.MOUSE_UP, goMouseUp);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, goMouseMove);
		}

		public function set distance(value : Number) : void {
			if (value > 0) return;
			_object.y = value;
		}

		public function get distance() : Number {
			return _object.y;
		}

		private function onMouseWheel(event : MouseEvent) : void {

			var newDistance : Number = distance + event.delta * (-distance * 0.05);

			if (newDistance > -5) newDistance = -5;
			if (newDistance < -100350) newDistance = -100350;

			_object.y = newDistance;
		}
	}
}
