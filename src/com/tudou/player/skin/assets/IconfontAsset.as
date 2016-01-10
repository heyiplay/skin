package com.tudou.player.skin.assets 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author kshen
	 */
	public class IconfontAsset extends DisplayObjectAsset
	{
		
		public function IconfontAsset(displayobject:DisplayObject) 
		{
			_displayobject = displayobject;
		}
		
		override public function get displayObject():DisplayObject
		{
			return _displayobject;
		}
		private var _displayobject:DisplayObject;
	}

}