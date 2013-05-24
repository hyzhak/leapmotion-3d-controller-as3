package org.hyzhak.leapmotion.controller3D.intersect.alternativa3D {
    import alternativa.engine3d.core.BoundBox;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.utils.Object3DUtils;

    import com.leapmotion.leap.Pointable;

    import org.hyzhak.leapmotion.controller3D.intersect.*;

    public class IntersectableObject3DAdapter implements IIntersectable {
        private var _object:Object3D;
        private var _bounds:BoundBox;
        private var _selectionView:SelectionViewBuilder;

        //ARCHITECTURE : key-value store used just for optimization,
        //because pointables can hover and unhover in any sequence.
        //So Vector or Array not such optimal for it.

        private var _pointables:Map = new Map();

        public function IntersectableObject3DAdapter(object:Object3D, selectionView:SelectionViewBuilder) {
            _object = object;
            _selectionView = selectionView;
            _bounds = Object3DUtils.calculateHierarchyBoundBox(object);
        }

        public function get pointables():Map {
            return _pointables;
        }

        public function get object3D():Object3D {
            return _object;
        }

        public function isIntersect(x:Number, y:Number, z:Number):Boolean {
            x -= _object.x;
            y -= _object.y;
            z -= _object.z;
            return  _bounds.minX <= x && x < _bounds.maxX &&
                    _bounds.minY <= y && y < _bounds.maxY &&
                    _bounds.minZ <= z && z < _bounds.maxZ;
        }

        public function hover(id:int, pointable:Pointable):Boolean {
            if (_pointables.getObject(id)) {
                //update with new pointable
                _pointables.putObject(id, pointable);
                return false;
            }

            _pointables.putObject(id, pointable);
            if (_pointables.size() >= 0) {
                hovered = true;
            }

            //trace("hover " + id + " _pointables", _pointables);
            return true;
        }

        public function unhover(id:int):Boolean {
            if (!_pointables.getObject(id)) {
                return false;
            }

            _pointables.remove(id);
            if (_pointables.size() <= 0) {
                hovered = false;
            }
            //trace("unhover " + id + " _pointables", _pointables);
            return true;
        }

        private var _hover:Boolean;

        private function set hovered(value:Boolean):void {
            if (_hover == value) {
                return;
            }

            _hover = value;

            if (_selectionView) {
                if (value) {
                    _selectionView.hover(_object, _bounds);
                } else {
                    _selectionView.unhover(_object, _bounds);
                }
            }
        }

        public function select():void {
            selected = true;
        }

        public function unselect():void {
            selected = false;
        }

        private var _selected:Boolean;

        private function set selected(value:Boolean):void {
            if (_selected == value) {
                return;
            }

            _selected = value;

            if (_selectionView) {
                if (value) {
                    _selectionView.select(_object, _bounds);
                } else {
                    _selectionView.unselect(_object, _bounds);
                }
            }
        }

        public function shift(dx:Number, dy:Number, dz:Number):void {
            _object.x += dx;
            _object.y += dy;
            _object.z += dz;
        }
    }
}
