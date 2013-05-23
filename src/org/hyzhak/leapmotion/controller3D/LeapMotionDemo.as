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
        private var _controller:Controller;
        private var _gesture3DController:LeapMotionGesture3DController;

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

            buildLeapMotionController();
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

            _gesture3DController = new LeapMotionGesture3DController(stage, object, _controller);

            _scene.initInstance();
            _scene.add3DObject(scene);
            _scene.add3DObject(new BlueCloudSkyBox());
//            _scene.add3DObject(new SpaceSkyBox());
//            _scene.add3DObject(new GloomySkyBox());

            _scene.add3DObject(new LeapMotionFingersView(_controller).withStage3D(stage.stage3Ds[0]));

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

        private function buildLeapMotionController():void {
            _controller = new Controller();

            _controller.addEventListener( LeapEvent.LEAPMOTION_INIT, onInit );
            _controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, onConnect );
            _controller.addEventListener( LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect );
            _controller.addEventListener( LeapEvent.LEAPMOTION_EXIT, onExit );
//            _controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
        }

        private function onInit(event:LeapEvent):void {
            trace("onInit");
        }

        private function onConnect(event:LeapEvent):void {
            trace("onConnect");
            _controller.enableGesture(Gesture.TYPE_CIRCLE);
            _controller.enableGesture(Gesture.TYPE_SWIPE );
            _controller.enableGesture(Gesture.TYPE_SCREEN_TAP);
        }

        private function onDisconnect(event:LeapEvent):void {
            trace("onDisconnect");
        }

        private function onExit(event:LeapEvent):void {
            trace("onExit");
        }

        private function onFrame(event:LeapEvent):void {
            // Get the most recent frame and report some basic information
            var frame:Frame = event.frame;
            trace( "Frame id: " + frame.id + ", timestamp: " + frame.timestamp + ", hands: " + frame.hands.length + ", fingers: " + frame.fingers.length + ", tools: " + frame.tools.length );

            var fingers:Vector.<Finger> = frame.fingers;


            for each(var finger:Finger in fingers.length) {
                if (finger.isValid()) {
                    finger.tipPosition;
                }
            }

            /*
            if ( frame.hands.length > 0 )
            {
                // Get the first hand
                var hand:Hand = frame.hands[ 0 ];

                // Check if the hand has any fingers
                var fingers:Vector.<Finger> = hand.fingers;
                if ( fingers.length > 0 )
                {
                    // Calculate the hand's average finger tip position
                    var avgPos:Vector3 = Vector3.zero();
                    for each ( var finger:Finger in fingers )
                        avgPos = avgPos.plus( finger.tipPosition );

                    avgPos = avgPos.divide( fingers.length );
                    trace( "Hand has " + fingers.length + " fingers, average finger tip position: " + avgPos );

                    finger = fingers[0];
                    var screen:Screen = _controller.closestScreenHitPointable(finger);
                    var pos:Vector3 = screen.intersectPointable(finger, false);
                }

                // Get the hand's sphere radius and palm position
                trace( "Hand sphere radius: " + hand.sphereRadius + " mm, palm position: " + hand.palmPosition );

                // Get the hand's normal vector and direction
                var normal:Vector3 = hand.palmNormal;
                var direction:Vector3 = hand.direction;

                // Calculate the hand's pitch, roll, and yaw angles
                trace( "Hand pitch: " + LeapUtil.toDegrees( direction.pitch ) + " degrees, " + "roll: " + LeapUtil.toDegrees( normal.roll ) + " degrees, " + "yaw: " + LeapUtil.toDegrees( direction.yaw ) + " degrees\n" );
            }
            */
        }
    }
}
