package org.hyzhak.leapmotion.controller3D {
    import alternativa.engine3d.core.Object3D;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.utils.Dictionary;

    import org.hyzhak.leapmotion.controller3D.alternativa3d.Alternativa3DStageBuilder;
    import org.hyzhak.leapmotion.controller3D.alternativa3d.scene.Scene3D;
    import org.hyzhak.leapmotion.controller3D.dragndrop.DragNDropController;
    import org.hyzhak.leapmotion.controller3D.fingers.LeapMotionFingersView;
    import org.hyzhak.leapmotion.controller3D.intersect.IIntersectable;
    import org.hyzhak.leapmotion.controller3D.intersect.IntersectEvent;
    import org.hyzhak.leapmotion.controller3D.intersect.LeapMotionIntersectSystem;
    import org.hyzhak.leapmotion.controller3D.intersect.Map;
    import org.hyzhak.leapmotion.controller3D.intersect.alternativa3D.IntersectableObject3DAdapter;
    import org.hyzhak.leapmotion.controller3D.intersect.alternativa3D.SelectionViewBuilder;
    import org.hyzhak.utils.PoolOfObjects;

    /**
     * Demo of LeapMotion interaction
     */
    [SWF(frameRate=60)]
    public class LeapMotionDemo extends Sprite {

        private var _alternativa3DStage:Alternativa3DStageBuilder;
        private var _leapmotion:LeapMotionSystem;
        private var _leapMotionIntersectSystem:LeapMotionIntersectSystem;

        private var _dragNDropControllers:Dictionary = new Dictionary();
        private var _poolOfDragNDropController:PoolOfObjects = new PoolOfObjects(DragNDropController);

        public function LeapMotionDemo() {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;

            _leapmotion = new LeapMotionSystem();

            buildIntersectSystem();
            build3DScene();
        }

        /**
         * Build system for tracking hover of pointable on 3D object
         */
        private function buildIntersectSystem():void {
            _leapMotionIntersectSystem = new LeapMotionIntersectSystem(_leapmotion.controller);
            _leapMotionIntersectSystem.transformation = _leapmotion.transformation;
            _leapMotionIntersectSystem.addEventListener(IntersectEvent.HOVER, onHover);
            _leapMotionIntersectSystem.addEventListener(IntersectEvent.UNHOVER, onUnHover);
        }

        /**
         * Handle hover event.
         * If we have more then one pointables hovered on 3D object we start dragging this object
         *
         * @param event
         */
        private function onHover(event:IntersectEvent):void {
            var pointables:Map = event.intersectable.pointables;
            if (pointables.size() >= 2) {
                startDragByLeapMotion(event.intersectable);
            }
        }

        /**
         * Handle unhover event.
         * If we have less then 2 fingers then we stop dragging
         *
         * @param event
         */
        private function onUnHover(event:IntersectEvent):void {
            var pointables:Map = event.intersectable.pointables;
            if (pointables.size() < 2) {
                stopDragByLeapMotion(event.intersectable);
            }
        }

        /**
         * Add controller for dragging 3D object
         *
         * @param intersectable
         */
        private function startDragByLeapMotion(intersectable:IIntersectable):void {
            var dragNDropController:DragNDropController = _dragNDropControllers[intersectable];
            if (dragNDropController == null) {
                dragNDropController = _poolOfDragNDropController.borrowObject();
                dragNDropController.controller = _leapmotion.controller;
                dragNDropController.intersectable = intersectable;
                dragNDropController.transformation = _leapmotion.transformation;

                _dragNDropControllers[intersectable] = dragNDropController;
                dragNDropController.start();
            }
        }

        /**
         * Remove dragging controller
         *
         * @param intersectable
         */
        private function stopDragByLeapMotion(intersectable:IIntersectable):void {
            var dragNDropController:DragNDropController = _dragNDropControllers[intersectable];
            if (dragNDropController) {
                dragNDropController.stop();
                delete _dragNDropControllers[intersectable];
                _poolOfDragNDropController.returnObject(dragNDropController);
            }
        }

        /**
         * build simple 3D Scene
         */
        private function build3DScene():void {
            _alternativa3DStage = new Alternativa3DStageBuilder();
            _alternativa3DStage.build();

            addChild(_alternativa3DStage);

            var scene:Scene3D = new Scene3D();
            var object:Object3D = scene.build(_alternativa3DStage);

            var selectionViewBuilder:SelectionViewBuilder = new SelectionViewBuilder().withStage3D(stage.stage3Ds[0]);

            _leapMotionIntersectSystem.intersectables.addChild(
                new IntersectableObject3DAdapter(object, selectionViewBuilder)
            );

            var fingersView:LeapMotionFingersView = new LeapMotionFingersView();
            fingersView.controller = _leapmotion.controller;
            fingersView.withStage3D = stage.stage3Ds[0];
            fingersView.transformation = _leapmotion.transformation;
            fingersView.build(_alternativa3DStage);

            validateSceneSize();
            stage.addEventListener(Event.RESIZE, onStageResize);
        }

        /**
         * update scene on stage resize
         *
         * @param event
         */
        private function onStageResize(event:Event):void {
            validateSceneSize();
        }

        /**
         * fit scene to the stage size
         */
        private function validateSceneSize():void {
            _alternativa3DStage.resize(stage.stageWidth, stage.stageHeight);
        }
    }
}
