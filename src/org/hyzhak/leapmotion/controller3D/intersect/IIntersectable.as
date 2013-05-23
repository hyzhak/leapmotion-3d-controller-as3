package org.hyzhak.leapmotion.controller3D.intersect {
    public interface IIntersectable {
        function isIntersect(x:Number, y:Number, z:Number):Boolean;

        function select():void;

        function unselect():void;

        function hover():void;

        function unhover():void;
    }
}
