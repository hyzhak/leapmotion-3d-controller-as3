package org.hyzhak.leapmotion.controller3D.alternativa3d {
    import org.hyzhak.leapmotion.controller3D.*;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Resource;
    import alternativa.engine3d.core.View;
    import alternativa.engine3d.lights.AmbientLight;
    import alternativa.engine3d.lights.DirectionalLight;

    import flash.display.Sprite;
    import flash.display.Stage3D;
    import flash.display3D.Context3D;
    import flash.events.Event;

    public class Alternativa3DStageBuilder extends Sprite {
        private var _rootContainer : Object3D;

        private var _camera:Camera3D;
        private var _stage3D:Stage3D;

        private var _viewWidth : Number = 640;
        private var _viewHeight : Number = 480;

        private var _cameraContainer : MouseOrbitCameraController;

        public function build() : void {
            _rootContainer = new Object3D();

            if (stage) {
                initStage3D();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
                addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
            }
        }

        public function get stage3D():Stage3D {
            return _stage3D;
        }

        public function get rootContainer():Object3D {
            return _rootContainer;
        }

        private function onAddedToStage(event : Event) : void {
            initStage3D();
        }

        private function onRemoveFromStage(event : Event) : void {
            // TODO Auto-generated method stub
        }

        private function initStage3D() : void {
            // Запрашиваем драйвер для работы с 3D
            _stage3D = stage.stage3Ds[0];
            _stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
            // Запрашиваем контекст
            _stage3D.requestContext3D();
        }

        protected function onContextCreate(event : Event) : void {
            _stage3D = event.currentTarget as Stage3D;
            var context3d:Context3D = _stage3D.context3D;

            buildCamera();

            initCameraView();

            buildCameraController();

            initLight();

            for each (var resource:Resource in _rootContainer.getResources(true)) {
                if (resource.isUploaded) continue;
                resource.upload(context3d);
            }

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function buildCamera() : void {

            _camera = new Camera3D(1, 50000);
            _camera.view = new View(1, 1, false, 0x393939, 1, 4);
        }

        private function buildCameraController() : void {
            _cameraContainer = new MouseOrbitCameraController(_camera, _camera.view, stage);
            _rootContainer.addChild(_cameraContainer);
            _cameraContainer.x = 0;
            _cameraContainer.y = 0;
            _cameraContainer.z = 0;
            _cameraContainer.rotationX = -Math.PI / 6;
            _cameraContainer.rotationY = 0;
            _cameraContainer.rotationZ = Math.PI / 6;
            _cameraContainer.distance = -500;
        }

        private function initCameraView() : void {
            resize(_viewWidth, _viewHeight);
            _camera.view.hideLogo();
            addChild(_camera.view);
        }

        public function resize(width : Number, height : Number) : void {
            if (_camera != null) {
                _camera.view.width = width;
                _camera.view.height = height;
            }

            _viewWidth = width;
            _viewHeight = height;
        }

        private function initLight() : void {
            var ambientLight : AmbientLight = new AmbientLight(0xffffff);
            ambientLight.intensity = 0.8;
            _rootContainer.addChild(ambientLight);

            var directionalLight : DirectionalLight = new DirectionalLight(0xffffff);
            directionalLight.intensity = 1;
            directionalLight.lookAt(0.5, 1, -1.5);
            _rootContainer.addChild(directionalLight);
        }

        private function onEnterFrame(event : Event) : void {
            _camera.render(_stage3D);
        }
    }
}
