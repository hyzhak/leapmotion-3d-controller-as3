package org.hyzhak.leapmotion.controller3D.intersect {
    public interface IIntersectable {
        function get selected():Boolean;
        function set selected(value:Boolean):void;

        function get hovered():Boolean;
        function set hovered(value:Boolean):void;

        function isIntersect(x:Number, y:Number, z:Number):Boolean;
    }
}
