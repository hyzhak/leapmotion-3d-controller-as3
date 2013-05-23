package org.hyzhak.leapmotion.controller3D {
    public class PoolOfObjects {
        private var _pool:Array = [];

        private var _ClassOfObjects:Class;

        public function PoolOfObjects(FingerClass:Class) {
            this._ClassOfObjects = FingerClass;
        }

        public function borrowObject():* {
            var instance:Object = _pool.pop();
            if (instance) {
                return instance;
            }

            return new this._ClassOfObjects();
        }

        public function returnObject(object:Object):void {
            _pool.push(object);
        }
    }
}
