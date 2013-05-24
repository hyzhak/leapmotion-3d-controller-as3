package org.hyzhak.leapmotion.controller3D {
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Finger;
    import com.leapmotion.leap.Frame;
    import com.leapmotion.leap.Gesture;
    import com.leapmotion.leap.Matrix;
    import com.leapmotion.leap.Vector3;
    import com.leapmotion.leap.events.LeapEvent;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.display.Stage3D;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.utils.Dictionary;

    import org.hyzhak.leapmotion.controller3D.dragndrop.DragNDropController;

    import org.hyzhak.leapmotion.controller3D.fingers.ArrowFingerView;

    import org.hyzhak.leapmotion.controller3D.fingers.LeapMotionFingersView;
    import org.hyzhak.leapmotion.controller3D.intersect.IIntersectable;
    import org.hyzhak.leapmotion.controller3D.intersect.IntersectEvent;
    import org.hyzhak.leapmotion.controller3D.intersect.alternativa3D.IntersectableObject3DAdapter;
    import org.hyzhak.leapmotion.controller3D.intersect.LeapMotionIntersectSystem;
    import org.hyzhak.leapmotion.controller3D.intersect.Map;
    import org.hyzhak.leapmotion.controller3D.intersect.SelectionViewBuilder;
    import org.hyzhak.leapmotion.controller3D.scene.DemoScene3D;
    import org.hyzhak.leapmotion.controller3D.skybox.bluecloud.BlueCloudSkyBox;
    import org.hyzhak.leapmotion.controller3D.skybox.gloomy.GloomySkyBox;

    import org.hyzhak.leapmotion.controller3D.skybox.space.SpaceSkyBox;

    public class LeapMotionDemo extends Sprite {

        private var _scene:Scene3D;
        private var _gesture3DController:LeapMotionGesture3DController;
        private var _leapmotion:LeapMotionSystem;
        private var _leapMotionIntersectSystem:LeapMotionIntersectSystem;

        private var _dragNDropControllers:Dictionary = new Dictionary();

        public function LeapMotionDemo() {

            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;

            _leapmotion = new LeapMotionSystem();
            _leapMotionIntersectSystem = new LeapMotionIntersectSystem(_leapmotion.controller);
            _leapMotionIntersectSystem.transformation = _leapmotion.transformation;
            _leapMotionIntersectSystem.addEventListener(IntersectEvent.HOVER, onHover);
            _leapMotionIntersectSystem.addEventListener(IntersectEvent.UNHOVER, onUnHover);
            build3DScene();
        }

        private function onHover(event:IntersectEvent):void {
            var pointables:Map = event.intersectable.pointables;
            if (pointables.size() >= 2) {
                startDragByLeapMotion(event.intersectable);
            }
        }

        private function onUnHover(event:IntersectEvent):void {
            var pointables:Map = event.intersectable.pointables;
            if (pointables.size() < 2) {
                stopDragByLeapMotion(event.intersectable);
            }
        }

        private function startDragByLeapMotion(intersectable:IIntersectable):void {
            var dragNDropController:DragNDropController = _dragNDropControllers[intersectable];
            if (dragNDropController == null) {
                //TODO : optimization - borrow dragNDropController from pool of objects
                dragNDropController = new DragNDropController();
                dragNDropController.controller = _leapmotion.controller;
                dragNDropController.intersectable = intersectable;
                dragNDropController.transformation = _leapmotion.transformation;

                _dragNDropControllers[intersectable] = dragNDropController;
                dragNDropController.start();
            }
        }

        private function stopDragByLeapMotion(intersectable:IIntersectable):void {
            var dragNDropController:DragNDropController = _dragNDropControllers[intersectable];
            if (dragNDropController) {
                dragNDropController.stop();
                delete _dragNDropControllers[intersectable];
                //TODO: optimization - return dragNDropController to pool of objects
            }
        }

        private function build3DScene():void {
            _scene = new Scene3D();
            _scene.initInstance();
            addChild(_scene);

            var scene:DemoScene3D = new DemoScene3D();

            var object:Object3D = scene.build();

            var selectionViewBuilder:SelectionViewBuilder = new SelectionViewBuilder().withStage3D(stage.stage3Ds[0]);

            //_gesture3DController = new LeapMotionGesture3DController(stage, object, _leapmotion.controller);

            _leapMotionIntersectSystem.intersectables.addChild(
                new IntersectableObject3DAdapter(object, selectionViewBuilder)
            );

            _scene.add3DObject(scene);

            var fingersView:LeapMotionFingersView = new LeapMotionFingersView(_leapmotion.controller);
            fingersView.withStage3D = stage.stage3Ds[0];
            fingersView.transformation = _leapmotion.transformation;

            _scene.add3DObject(fingersView);
            _scene.add3DObject(new BlueCloudSkyBox());
//            _scene.add3DObject(new SpaceSkyBox());
//            _scene.add3DObject(new GloomySkyBox());

            validateSceneSize();

            stage.addEventListener(Event.RESIZE, onStageResize);
        }

        private function onStageResize(event:Event):void {
            validateSceneSize();
        }

        private function validateSceneSize():void {
            _scene.resize(stage.stageWidth, stage.stageHeight);
        }
    }
}
