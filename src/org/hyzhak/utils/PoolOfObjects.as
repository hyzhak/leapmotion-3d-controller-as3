package org.hyzhak.utils {
    public class PoolOfObjects {
        private var _pool:Array = [];

        private var _ClassOfObjects:Class;

        private var _factoryFunction:Function;

        public function PoolOfObjects(FingerClass:Class, factoryFunction:Function = null) {
            _ClassOfObjects = FingerClass;
            _factoryFunction = factoryFunction;
        }

        public function borrowObject():* {
            var instance:Object = _pool.pop();
            if (instance) {
                return instance;
            }

            if (_factoryFunction) {
                return _factoryFunction();
            } else {
                return new this._ClassOfObjects();
            }
        }

        public function returnObject(object:Object):void {
            _pool.push(object);
        }
    }
}
