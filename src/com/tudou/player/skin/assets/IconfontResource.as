package com.tudou.player.skin.assets 
{
	/**
	 * ...
	 * @author kshen
	 */
	public class IconfontResource extends AssetResource
	{
		
		public function IconfontResource(id:String, url:String, local:Boolean, iconText:String, iconWidth:String, iconColor:String, width:String, height:String)
		{
			_iconText = iconText;
			_iconWidth = iconWidth;
			_iconColor = iconColor;
			_width = width;
			_height = height;
			super(id, url, local);
		}
		
		public function get iconText():String
		{
			return _iconText;
		}
		public function get iconWidth():String
		{
			return _iconWidth;
		}
		public function get iconColor():String
		{
			return _iconColor;
		}
		public function get width():String
		{
			return _width;
		}
		public function get height():String
		{
			return _height;
		}
		
		private var _iconText:String;
		private var _iconWidth:String;
		private var _iconColor:String;
		private var _width:String;
		private var _height:String;
		
	}

}