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
    import org.hyzhak.leapmotion.controller3D.skybox.bluecloud.BlueCloudSkyBox;
    import org.hyzhak.leapmotion.controller3D.skybox.gloomy.GloomySkyBox;

    import org.hyzhak.leapmotion.controller3D.skybox.space.SpaceSkyBox;

    public class LeapMotionDemo extends Sprite {

        private var _scene:Scene3D;
        private var _gesture3DController:LeapMotionGesture3DController;
        private var _leapmotion:LeapMotionSystem;

        //source : http://opengameart.org/content/syntmetal04
        [Embed(source="/assets/synthetic_metal_04_diffuse.png")]
        private static const DIFFUSE_MAP:Class;

        [Embed(source="/assets/synthetic_metal_04_normal.png")]
        private static const NORMAL_MAP:Class;

        [Embed(source="/assets/synthetic_metal_04_specular.png")]
        private static const SPECULAR_MAP:Class;

        public function LeapMotionDemo() {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;

            _leapmotion = new LeapMotionSystem();
            //buildLeapMotionController();
            build3DScene();
        }

        private function build3DScene():void {
            _scene = new Scene3D();

            var scene:Document3DScene = new Document3DScene();
            scene.diffuseMap = (new DIFFUSE_MAP() as Bitmap).bitmapData;
            scene.normalMap = (new NORMAL_MAP() as Bitmap).bitmapData;
            scene.specularMap = (new SPECULAR_MAP() as Bitmap).bitmapData;
            scene.specularPower = 0.5

            var object:Object3D = scene.build();

            _gesture3DController = new LeapMotionGesture3DController(stage, object, _leapmotion.controller);

            _scene.initInstance();
            _scene.add3DObject(scene);
            _scene.add3DObject(new BlueCloudSkyBox());
//            _scene.add3DObject(new SpaceSkyBox());
//            _scene.add3DObject(new GloomySkyBox());

            _scene.add3DObject(new LeapMotionFingersView(_leapmotion.controller).withStage3D(stage.stage3Ds[0]));

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
