package com.tudou.player.skin.assets
{
	import flash.geom.Rectangle;
	
	public class BitmapResource extends AssetResource
	{
		public function BitmapResource(id:String, url:String, local:Boolean, scale9:Rectangle)
		{
			_scale9 = scale9;
			
			super(id, url, local);
		}
		
		public function get scale9():Rectangle
		{
			return _scale9;	
		}
		
		private var _scale9:Rectangle;
	}
}