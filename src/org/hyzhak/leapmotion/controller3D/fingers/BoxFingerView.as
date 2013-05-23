package org.hyzhak.leapmotion.controller3D.fingers {
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.primitives.Box;

    public class BoxFingerView extends AbstractFingerView {
        public function BoxFingerView() {
            super();
            var box : Box = new Box(2, 2, 1);
            box.setMaterialToAllSurfaces(new FillMaterial(0xFF0000));
            addChild(box);
        }
    }
}
