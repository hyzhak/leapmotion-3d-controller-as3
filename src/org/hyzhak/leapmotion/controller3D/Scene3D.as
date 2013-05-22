package org.hyzhak.leapmotion.controller3D {
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

    public class Scene3D extends Sprite {
        private var _rootContainer : Object3D;

        private var _camera:Camera3D;
        private var _stage3D:Stage3D;

        private var _viewWidth : Number = 640;
        private var _viewHeight : Number = 480;

        private var _cameraContainer : MouseCameraController;

        public var demoScene : Document3DScene;

        public function initInstance() : void {
            _rootContainer = new Object3D();

            if (stage) {
                initStage3D();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
                addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
            }
        }

        public function add3DObject(obj:Object3D):void {
            _rootContainer.addChild(obj);
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

            buildScene();

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
//            camera.effectMode = 9;
//            camera.ssaoAngular.secondPassOccludingRadius = 1.189999999999999;
//            camera.ssaoAngular.angleThreshold = 0.30000000000000004;
//            camera.ssaoAngular.occludingRadius = 39.800000000000296;
//            camera.ssaoAngular.secondPassAmount = 0.8999999999999992;
//            camera.ssaoAngular.maxDistance = 33.7;
//            camera.ssaoAngular.falloff = 316;
//            camera.ssaoAngular.intensity = 0.7499999999999999;
//            previewModel.camera = camera;
        }

        private function buildCameraController() : void {
            _cameraContainer = new MouseCameraController(_camera, _camera.view, stage);
            _rootContainer.addChild(_cameraContainer);
            _cameraContainer.x = 0;
            _cameraContainer.y = 0;
            _cameraContainer.z = 0;
            _cameraContainer.rotationX = -Math.PI / 6;
            _cameraContainer.rotationY = 0;
            _cameraContainer.rotationZ = Math.PI / 6;
            _cameraContainer.distance = -200;
        }

        private function buildScene() : void {
            // var tr:TextureResource = new TextureResource();
            demoScene.forStage3D(_stage3D).build();
            _rootContainer.addChild(demoScene);
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
