package org.hyzhak.leapmotion.controller3D.intersect {
    import com.leapmotion.leap.Pointable;

    public interface IIntersectable {
        function hover(id:int, pointable:Pointable):Boolean;
        function unhover(id:int):Boolean;

        function isIntersect(x:Number, y:Number, z:Number):Boolean;

        function get pointables():Map;
    }
}
