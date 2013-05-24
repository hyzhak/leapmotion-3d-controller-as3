package org.hyzhak.leapmotion.controller3D.dragndrop {
    import com.leapmotion.leap.Controller;
    import com.leapmotion.leap.Frame;
    import com.leapmotion.leap.Pointable;
    import com.leapmotion.leap.events.LeapEvent;

    import flash.utils.Dictionary;

    import org.hyzhak.leapmotion.controller3D.intersect.IIntersectable;

    public class DragNDropController {
        public var controller:Controller;

        public var intersectable:IIntersectable;

        public function start():void {
            trace("DragNDropController.start");
            controller.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
        }

        public function stop():void {
            trace("DragNDropController.stop");
            controller.removeEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
        }

        private function onFrame(event:LeapEvent):void {
            var frame:Frame = event.frame;
            var usedPointables:Dictionary = intersectable.pointables.collection;
            for(var id:Object in usedPointables) {
                var pointable:Pointable = frame.pointable(id as int);
                pointable.tipPosition;

                //0. transpose coordinates

                //1. get start position

                //2. calc relevant position

                //3. use average position

                //4. calc rotation

                //5. apply position
            }

            //TODO : drag n drop
        }
    }
}
