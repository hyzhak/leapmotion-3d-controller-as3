package org.hyzhak.leapmotion.controller3D.skybox.gloomy {
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.objects.SkyBox;
    import alternativa.engine3d.resources.BitmapTextureResource;

    public class GloomySkyBox extends SkyBox {
        //source : http://opengameart.org/content/cloudy-s
        [Embed(source="gloomy_lf.png")] static private const left_t_c:Class;
        private var left_t:BitmapTextureResource = new BitmapTextureResource(new left_t_c().bitmapData);
        [Embed(source="gloomy_rt.png")] static private const right_t_c:Class;
        private var right_t:BitmapTextureResource = new BitmapTextureResource(new right_t_c().bitmapData);
        [Embed(source="gloomy_up.png")] static private const top_t_c:Class;
        private var top_t:BitmapTextureResource = new BitmapTextureResource(new top_t_c().bitmapData);
        [Embed(source="gloomy_dn.png")] static private const bottom_t_c:Class;
        private var bottom_t:BitmapTextureResource = new BitmapTextureResource(new bottom_t_c().bitmapData);
        [Embed(source="gloomy_ft.png")] static private const front_t_c:Class;
        private var front_t:BitmapTextureResource = new BitmapTextureResource(new front_t_c().bitmapData);
        [Embed(source="gloomy_bk.png")] static private const back_t_c:Class;
        private var back_t:BitmapTextureResource = new BitmapTextureResource(new back_t_c().bitmapData);

        public function GloomySkyBox() {
            super(3000,
                new TextureMaterial(back_t), 		//Material for back side
                new TextureMaterial(front_t), 		//Material for front side

                new TextureMaterial(left_t),		//Material for left side
                new TextureMaterial(right_t), 		//Material for right side

                new TextureMaterial(bottom_t), 		//Material for bottom side
                new TextureMaterial(top_t), 		//Material for top side
                0.01);
        }
    }
}
