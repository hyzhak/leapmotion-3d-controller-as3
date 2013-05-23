package org.hyzhak.leapmotion.controller3D.fingers {
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.primitives.Box;

    public class ArrowFingerView extends AbstractFingerView {
        public function ArrowFingerView() {
            super();
            var box : Box = new Box(100, 100);
            box.setMaterialToAllSurfaces(new FillMaterial(0xFF0000));
            addChild(box);
        }
    }
}
