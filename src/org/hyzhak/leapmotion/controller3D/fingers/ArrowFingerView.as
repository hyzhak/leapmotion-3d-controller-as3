package org.hyzhak.leapmotion.controller3D.fingers {
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.primitives.Box;
    import alternativa.engine3d.primitives.GeoSphere;

    public class ArrowFingerView extends AbstractFingerView {
        public function ArrowFingerView() {
            var material:FillMaterial = new FillMaterial(0xFFFF00);
            var box : Box = new Box(2, 2, 100);
            box.setMaterialToAllSurfaces(material);
            box.z = 50;
            addChild(box);
            var sphere:GeoSphere = new GeoSphere(4);
            sphere.setMaterialToAllSurfaces(material);
            addChild(sphere);
        }
    }
}
