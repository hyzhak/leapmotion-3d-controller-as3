package org.hyzhak.leapmotion.controller3D.intersect {
    import alternativa.engine3d.core.BoundBox;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.utils.Object3DUtils;

    public class IntersectableObject3DAdapter implements IIntersectable{
        private var _object:Object3D;
        private var _bounds:BoundBox;
        private var _selectionView:SelectionView;

        private var _hover:Boolean;
        private var _selected:Boolean;

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

        public function get hovered():Boolean {
            return _hover;
        }

        public function set hovered(value:Boolean):void {
            if (_hover == value) {
                return;
            }

            _hover = value;

            if (value) {
                _selectionView.hover(_object);
            } else {
                _selectionView.unhover(_object);
            }
        }

        public function get selected():Boolean {
            return _selected;
        }

        public function set selected(value:Boolean):void {
            if (_selected == value) {
                return;
            }

            _selected = value;
            if (value) {
                _selectionView.select(_object);
            } else {
                _selectionView.unselect(_object);
            }
        }
    }
}
