package com.tudou.player.skin.configuration
{
	import com.tudou.player.skin.assets.IconfontResource;
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	
	import com.tudou.player.skin.assets.AssetLoader;
	import com.tudou.player.skin.assets.AssetResource;
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.skin.assets.BitmapResource;
	import com.tudou.player.skin.assets.FontResource;
	import com.tudou.player.skin.assets.SymbolResource;
	
	public class AssetsParser
	{
		public function parse(assetsList:XMLList, assetsManager:AssetsManager):void
		{
			for each (var asset:XML in assetsList)
			{
				var loader:AssetLoader;
				var resource:AssetResource;
				loader = new AssetLoader();
				resource = assetToResource(asset);
				if (loader && resource)
				{
					assetsManager.addAsset(resource, loader);
				}
				else{
					throw new IllegalOperationError("无法识别asset类型", asset.@url);
				}
			}
		}
		
		// Internals
		//
		
		private function assetToResource(asset:XML):AssetResource
		{
			var type:String = String(asset.@type || "").toLowerCase();
			var resource:AssetResource;
			
			switch (type)
			{
				case "bitmapfile":
				case "bitmapsymbol":
					resource = new BitmapResource
						( asset.@id
						, asset.@url
						, type == "bitmapsymbol"
						, parseRect(asset.@scale9)
						);
					break;
					
				case "fontfile":
				case "fontsymbol":	
					resource = new FontResource
						( asset.@id
						, asset.@url
						, type == "fontsymbol"
						, (type == "fontsymbol")?asset.@url:asset.@symbol
						, parseInt(asset.@size || "12")
						, parseInt(asset.@color || "0xFFFFFF")
						);
					break;
					
				case "symbol":
					resource = new SymbolResource
						(asset.@id
						, asset.@url
						, true
						, asset.@url
					);
					break;
				case "iconfont":
					resource = new IconfontResource
						(asset.@id
						, ""
						, true
						, asset.@iconText
						, asset.@iconWidth
						, asset.@iconColor
						, asset.@width
						, asset.@height
					)
					break;
			}
			
			return resource;
		}
		
		private function parseRect(value:String):Rectangle
		{
			var result:Rectangle;
			
			var values:Array = value.split(",");
			if (values.length == 4)
			{
				result
					= new Rectangle
						( parseInt(values[0])
						, parseInt(values[1])
						, parseInt(values[2])
						, parseInt(values[3])
						);
			}
			
			return result;
		} 
	}
}