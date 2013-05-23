package org.hyzhak.leapmotion.controller3D.intersect {
    import alternativa.engine3d.core.BoundBox;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.utils.Object3DUtils;

    public class IntersectableObject3DAdapter implements IIntersectable{
        private var _object:Object3D;
        private var _bounds:BoundBox;
        private var _selectionView:SelectionView;

        public function IntersectableObject3DAdapter(object:Object3D, selectionView:SelectionView) {
            _object = object;
            _selectionView = selectionView;
            _bounds = Object3DUtils.calculateHierarchyBoundBox(object);
        }

        public function isIntersect(x:Number, y:Number, z:Number):Boolean {
            return  _bounds.minX <= x && x < _bounds.maxX &&
                    _bounds.minY <= y && y < _bounds.maxY &&
                    _bounds.minZ <= z && z < _bounds.maxZ;
        }

        public function select():void {
            _selectionView.select(_object);
        }

        public function unselect():void {
            _selectionView.unselect(_object);
        }

        public function hover():void {
            _selectionView.hover(_object);
        }

        public function unhover():void {
            _selectionView.unhover(_object);
        }
    }
}
