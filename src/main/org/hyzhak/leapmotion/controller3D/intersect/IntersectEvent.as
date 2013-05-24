package org.hyzhak.leapmotion.controller3D.intersect {
    import flash.events.Event;

    public class IntersectEvent extends Event {

        public static const HOVER:String = "hover";
        public static const UNHOVER:String = "unhover";

        public var intersectable:IIntersectable;

        public function IntersectEvent(type:String, intersectable:IIntersectable, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
            this.intersectable = intersectable;
        }

        override public function clone():Event {
            return new IntersectEvent(type, intersectable, bubbles, cancelable);
        }
    }
}
