package org.hyzhak.leapmotion.controller3D {
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.materials.StandardMaterial;
    import alternativa.engine3d.primitives.Box;
    import alternativa.engine3d.resources.BitmapTextureResource;
    import alternativa.engine3d.resources.TextureResource;

    import flash.display.BitmapData;
    import flash.display.Stage3D;

    public class Document3DScene extends Object3D {
		private var _stage3D : Stage3D;

		private var _specularPower : Number = 1.0;

		private var _material : StandardMaterial;

		private var _defaultWhiteTexture : TextureResource;
		private var _defaultNormalMap:BitmapTextureResource;

        public var diffuseMap:BitmapData;
        public var normalMap:BitmapData;
        public var specularMap:BitmapData;

		public function forStage3D(value : Stage3D) : Document3DScene {
			_stage3D = value;
			return this;
		}

		public function build() : void {
			buildDefaultWhiteTexture();
			buildDefaultNormalMap();

			_material = new StandardMaterial();

			var box : Box = new Box();
			box.setMaterialToAllSurfaces(_material);
			addChild(box);

            updateDiffuse();
            updateNormal();
            updateSpecular();
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
			_defaultWhiteTexture.upload(_stage3D.context3D);
		}

		private function buildDefaultNormalMap() : void {
			var bitmap : BitmapData = new BitmapData(1, 1);
			bitmap.setPixel(0, 0, 0x7F7FFF);
			_defaultNormalMap = new BitmapTextureResource(bitmap, true);
			_defaultNormalMap.upload(_stage3D.context3D);
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
                resource.upload(_stage3D.context3D);
            }

            if (_material != null && _material[mapName] != resource) {
                var oldResource : TextureResource = _material[mapName];
                _material[mapName] = resource;

                if (oldResource != null && oldResource != defaultResource) {
                    oldResource.dispose();
                }
            }
        }

		public function get specularPower() : Number {
			return _specularPower;
		}

		public function set specularPower(value : Number) : void {
			if (_specularPower == value) {
				return;
			}

			_specularPower = value;

			if (_material != null) {
				_material.specularPower = value;
			}
		}
	}
}