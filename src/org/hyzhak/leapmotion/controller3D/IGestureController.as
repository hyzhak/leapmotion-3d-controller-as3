package org.hyzhak.leapmotion.controller3D {
    import alternativa.engine3d.core.Object3D;

    import com.leapmotion.leap.Gesture;

    public interface IGestureController {
        function applyTo(object:Object3D):void;
        function updateWith(gesture:Gesture):void;
    }
}
