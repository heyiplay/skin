package com.tudou.player.skin.assets
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	import com.tudou.player.skin.utils.Scale9Bitmap;
	
	public class BitmapAsset extends DisplayObjectAsset
	{
		public function BitmapAsset(bitmap:Bitmap, scale9:Rectangle = null)
		{
			_bitmap = bitmap;
			_scale9 = scale9;
			super();
		}
		
		override public function get displayObject():DisplayObject
		{
			return _scale9
				? new Scale9Bitmap(_bitmap, _scale9)
				: new Bitmap(_bitmap.bitmapData.clone(), _bitmap.pixelSnapping, _bitmap.smoothing);
		}
		
		private var _bitmap:Bitmap;
		private var _scale9:Rectangle;
		
	}
}