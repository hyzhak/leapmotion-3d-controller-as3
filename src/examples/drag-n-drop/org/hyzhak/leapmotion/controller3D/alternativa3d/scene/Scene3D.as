package org.hyzhak.leapmotion.controller3D.alternativa3d.scene {
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.materials.StandardMaterial;
    import alternativa.engine3d.primitives.Box;
    import alternativa.engine3d.resources.BitmapTextureResource;
    import alternativa.engine3d.resources.TextureResource;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Stage3D;

    import org.hyzhak.leapmotion.controller3D.alternativa3d.Alternativa3DStageBuilder;

    import org.hyzhak.leapmotion.controller3D.alternativa3d.skybox.bluecloud.BlueCloudSkyBox;

    import org.hyzhak.leapmotion.controller3D.utils.BitUtils;

    /**
     * Test scene
     *
     */
    public class Scene3D extends Object3D {
		private var _stage3D : Stage3D;

		private var _material : StandardMaterial;

		private var _defaultWhiteTexture : TextureResource;
		private var _defaultNormalMap:BitmapTextureResource;

        //source : http://opengameart.org/content/syntmetal04
        [Embed(source="synthetic_metal_04_diffuse.png")]
        private static const DIFFUSE_MAP:Class;

        [Embed(source="synthetic_metal_04_normal.png")]
        private static const NORMAL_MAP:Class;

        [Embed(source="synthetic_metal_04_specular.png")]
        private static const SPECULAR_MAP:Class;

        public var diffuseMap:BitmapData = (new DIFFUSE_MAP() as Bitmap).bitmapData;
        public var normalMap:BitmapData = (new NORMAL_MAP() as Bitmap).bitmapData;
        public var specularMap:BitmapData = (new SPECULAR_MAP() as Bitmap).bitmapData;

		public function forStage3D(value : Stage3D) : Scene3D {
			_stage3D = value;
			return this;
		}

		public function build(stage:Alternativa3DStageBuilder) : Object3D {
			buildDefaultWhiteTexture();
			buildDefaultNormalMap();

			_material = new StandardMaterial();

			var box : Box = new Box(50, 50, 50);
			box.setMaterialToAllSurfaces(_material);
            box.z = 150;

            stage.rootContainer.addChild(box);

            updateDiffuse();
            updateNormal();
            updateSpecular();

            stage.rootContainer.addChild(new BlueCloudSkyBox());

            return box;
		}

        // --------------------------------------------------------------------------
        //
        // Default
        //
        // --------------------------------------------------------------------------

		private function buildDefaultWhiteTexture() : void {
			var bitmap : BitmapData = new BitmapData(1, 1);
			bitmap.setPixel(0, 0, 0xFFFFFF);
			_defaultWhiteTexture = new BitmapTextureResource(bitmap, true);
            if (_stage3D && _stage3D.context3D) {
			    _defaultWhiteTexture.upload(_stage3D.context3D);
            }
		}

		private function buildDefaultNormalMap() : void {
			var bitmap : BitmapData = new BitmapData(1, 1);
			bitmap.setPixel(0, 0, 0x7F7FFF);
			_defaultNormalMap = new BitmapTextureResource(bitmap, true);
            if (_stage3D && _stage3D.context3D) {
			    _defaultNormalMap.upload(_stage3D.context3D);
            }
		}

		private function updateDiffuse() : void {
            updateMap(diffuseMap, "diffuseMap", _defaultWhiteTexture);
		}

		private function updateNormal() : void {
            updateMap(normalMap, "normalMap", _defaultNormalMap);
		}

		private function updateSpecular() : void {
            updateMap(specularMap, "specularMap", _defaultWhiteTexture);
		}

        private function updateMap(mapData:BitmapData, mapName:String, defaultResource:TextureResource):void {
            var resource : TextureResource;

            if (mapData == null) {
                resource = defaultResource;
            } else {
                var bitmap : BitmapData = mapData;
                if (!BitUtils.isBitmapDataPowOf2(bitmap)) {
                    throw new Error(mapName + " must has width and height power of 2. Not " + bitmap.width + "x" + bitmap.height);
                }
                resource = new BitmapTextureResource(bitmap, true);
//                resource.upload(_stage3D.context3D);
            }

            if (_material != null && _material[mapName] != resource) {
                var oldResource : TextureResource = _material[mapName];
                _material[mapName] = resource;

                if (oldResource != null && oldResource != defaultResource) {
                    oldResource.dispose();
                }
            }
        }
	}
}