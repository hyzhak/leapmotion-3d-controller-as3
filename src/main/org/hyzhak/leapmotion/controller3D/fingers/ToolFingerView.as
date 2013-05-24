package org.hyzhak.leapmotion.controller3D.fingers {
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.materials.Material;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.primitives.Box;
    import alternativa.engine3d.primitives.GeoSphere;

    public class ToolFingerView extends AbstractFingerView {
        private static var box : Box = new Box(2, 2, 100);
        private static var sphere:GeoSphere = new GeoSphere(4);
        private static var material:Material = new FillMaterial(0xFF0000);

        public function ToolFingerView() {
            var mesh:Mesh = box.clone() as Mesh;
            mesh.setMaterialToAllSurfaces(material);
            mesh.z = 50;
            addChild(mesh);

            mesh = sphere.clone() as Mesh;
            mesh.setMaterialToAllSurfaces(material);
            addChild(mesh);
        }
    }
}
