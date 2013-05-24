package org.hyzhak.leapmotion.controller3D.intersect {
    public class Map {
        private var _size:int = 0;

        private var _map:Object = {};

        public function size():int {
            return _size;
        }

        public function getObject(key:Object):* {
            return _map[key];
        }

        public function putObject(key:Object, value:Object):void {
            if (!_map[key]) {
                _size++;
            }
            _map[key] = value;
        }

        public function remove(key:Object):void {
            if (_map[key]) {
                _size--;
            }
            delete _map[key];
        }

        public function get collection():Object {
            return _map;
        }
    }
}
