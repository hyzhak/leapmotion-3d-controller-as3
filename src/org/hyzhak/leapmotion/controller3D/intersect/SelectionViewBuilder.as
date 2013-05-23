package org.hyzhak.leapmotion.controller3D.intersect {
    import alternativa.engine3d.core.BoundBox;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Resource;
    import alternativa.engine3d.objects.WireFrame;
    import alternativa.engine3d.primitives.Box;

    import flash.display.Stage3D;

    public class SelectionViewBuilder {
        private static const HOVER_STEP:int = 16;

        private var hoverObject:Object3D = WireFrame.createEdges(new Box(), 0x00ffff, 1, 3);
        private var selectObject:Object3D = WireFrame.createEdges(new Box(), 0x00ff00, 1, 3);

        private var _stage3D:Stage3D;

        public function hover(object:Object3D, bounds:BoundBox):void {
            var resources:Vector.<Resource> = hoverObject.getResources();
            for each(var resource:Resource in resources) {
                if (!resource.isUploaded) {
                    resource.upload(_stage3D.context3D);
                }
            }

            hoverObject.scaleX = (bounds.maxX - bounds.minX + HOVER_STEP) / 100;
            hoverObject.scaleY = (bounds.maxY - bounds.minY + HOVER_STEP) / 100;
            hoverObject.scaleZ = (bounds.maxZ - bounds.minZ + HOVER_STEP) / 100;
            object.addChild(hoverObject);
        }

        public function unhover(object:Object3D, bounds:BoundBox):void {
            if (hoverObject.parent) {
                hoverObject.parent.removeChild(hoverObject);
            }
        }
        public function select(object:Object3D, bounds:BoundBox):void {
            unhover(object, bounds);

            var resources:Vector.<Resource> = selectObject.getResources();
            for each(var resource:Resource in resources) {
                if (!resource.isUploaded) {
                    resource.upload(_stage3D.context3D);
                }
            }

            selectObject.scaleX = (bounds.maxX - bounds.minX + HOVER_STEP) / 100;
            selectObject.scaleY = (bounds.maxY - bounds.minY + HOVER_STEP) / 100;
            selectObject.scaleZ = (bounds.maxZ - bounds.minZ + HOVER_STEP) / 100;
            object.addChild(selectObject);
        }

        public function unselect(object:Object3D, bounds:BoundBox):void {
            if (selectObject.parent) {
                selectObject.parent.removeChild(selectObject);
            }
        }

        public function withStage3D(stage3D:Stage3D):SelectionViewBuilder {
            _stage3D = stage3D;
            return this;
        }
    }
}
