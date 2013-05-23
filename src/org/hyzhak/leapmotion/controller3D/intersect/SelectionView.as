package org.hyzhak.leapmotion.controller3D.intersect {
    import alternativa.engine3d.core.Object3D;

    public class SelectionView extends Object3D{
        public function select(object:Object3D):void {
            trace("select!", object);
        }

        public function unselect(object:Object3D):void {
            trace("unselect!", object);
        }

        public function hover(object:Object3D):void {
            trace("hover!", object);
        }

        public function unhover(object:Object3D):void {
            trace("unhover!", object);
        }
    }
}
