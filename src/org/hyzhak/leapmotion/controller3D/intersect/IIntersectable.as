package org.hyzhak.leapmotion.controller3D.intersect {
    public interface IIntersectable {
        function get hovered():Boolean;
        function set hovered(value:Boolean):void;

        function isIntersect(x:Number, y:Number, z:Number):Boolean;
    }
}
