package org.hyzhak.leapmotion.controller3D.fingers {
    import alternativa.engine3d.core.Resource;

    import flash.display.Stage3D;

    public class PointablesPool {

        public var stage3D:Stage3D;

        private var _pool:Vector.<AbstractFingerView> = new <AbstractFingerView>[];

        private var FingerClass:Class;

        public function PointablesPool(FingerClass:Class) {
            this.FingerClass = FingerClass;
        }

        public function borrowObject():AbstractFingerView {
            var instance:AbstractFingerView = _pool.pop();
            if (instance) {
                return instance;
            }

            instance = new this.FingerClass();

            for each (var boxResource:Resource in instance.getResources(true)) {
                if (!boxResource.isUploaded) {
                    boxResource.upload(stage3D.context3D);
                }
            }

            return instance;
        }

        public function returnObject(finger:AbstractFingerView):void {
            _pool.push(finger);
        }
    }
}
