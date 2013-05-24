package org.hyzhak.leapmotion.controller3D.intersect {
    import com.leapmotion.leap.Pointable;

    public interface IIntersectable {
        function hover(pointable:Pointable):Boolean;
        function unhover(pointable:Pointable):Boolean;

        function isIntersect(x:Number, y:Number, z:Number):Boolean;

        function get pointables():Map;
    }
}
