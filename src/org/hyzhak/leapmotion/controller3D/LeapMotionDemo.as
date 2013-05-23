package org.hyzhak.leapmotion.controller3D {
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Finger;
    import com.leapmotion.leap.Frame;
    import com.leapmotion.leap.Gesture;
    import com.leapmotion.leap.events.LeapEvent;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    import org.hyzhak.leapmotion.controller3D.fingers.ArrowFingerView;

    import org.hyzhak.leapmotion.controller3D.fingers.LeapMotionFingersView;
    import org.hyzhak.leapmotion.controller3D.scene.DemoScene3D;
    import org.hyzhak.leapmotion.controller3D.skybox.bluecloud.BlueCloudSkyBox;
    import org.hyzhak.leapmotion.controller3D.skybox.gloomy.GloomySkyBox;

    import org.hyzhak.leapmotion.controller3D.skybox.space.SpaceSkyBox;

    public class LeapMotionDemo extends Sprite {

        private var _scene:Scene3D;
        private var _gesture3DController:LeapMotionGesture3DController;
        private var _leapmotion:LeapMotionSystem;

        public function LeapMotionDemo() {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;

            _leapmotion = new LeapMotionSystem();
            build3DScene();
        }

        private function build3DScene():void {
            _scene = new Scene3D();
            _scene.initInstance();

            var scene:DemoScene3D = new DemoScene3D();

            var object:Object3D = scene.build();
            _gesture3DController = new LeapMotionGesture3DController(stage, object, _leapmotion.controller);

            _scene.add3DObject(scene);
            _scene.add3DObject(new LeapMotionFingersView(_leapmotion.controller).withStage3D(stage.stage3Ds[0]));
            _scene.add3DObject(new BlueCloudSkyBox());
//            _scene.add3DObject(new SpaceSkyBox());
//            _scene.add3DObject(new GloomySkyBox());


            validateSceneSize();
            addChild(_scene);

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
