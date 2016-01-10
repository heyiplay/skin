package com.tudou.player.skin.assets
{
	import flash.display.DisplayObject;
	import flash.display.Loader;

	public class SWFAsset extends DisplayObjectAsset
	{
		public function SWFAsset(displayObject:DisplayObject)
		{
			_displayObject = displayObject;
			
			super();
		}
		
		override public function get displayObject():DisplayObject
		{
			return _displayObject;
		}
		
		private var _displayObject:DisplayObject;
	}
}