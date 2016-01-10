package com.tudou.player.skin.widgets 
{
	import com.tudou.player.skin.utils.Scale9Bitmap;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * PanelBg
	 * 
	 * @author 8088
	 */
	public class PanelBg extends Scale9Bitmap
	{
		
		public function PanelBg(assets:DisplayObject):void
		{
			var w:Number = assets.width;
			var h:Number = assets.height;
			var bmd:BitmapData = new BitmapData(w + 20, h + 20, true, 0);
			
			var matrix:Matrix = new Matrix(1, 0, 0, 1, 10, 10);
			bmd.draw(assets, matrix, null, null, null, true);
			var bmp:Bitmap = new Bitmap(bmd);
			
			var grid:Rectangle = new Rectangle(20, 20, w -20, h - 20);
			
			super(bmp, grid);
		}
		
	}

}