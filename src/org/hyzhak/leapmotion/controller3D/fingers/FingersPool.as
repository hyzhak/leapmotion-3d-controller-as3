package org.hyzhak.leapmotion.controller3D.fingers {
    public class FingersPool {

        private var _pool:Vector.<AbstractFingerView> = new <AbstractFingerView>[];

        private var FingerClass:Class;

        public function FingersPool(FingerClass:Class) {
            this.FingerClass = FingerClass;
        }

        public function borrowObject():AbstractFingerView {
            var instance:AbstractFingerView = _pool.pop();
            if (instance) {
                return instance;
            }

            return new this.FingerClass();
        }

        public function returnObject(finger:AbstractFingerView):void {
            _pool.push(finger);
        }
    }
}
