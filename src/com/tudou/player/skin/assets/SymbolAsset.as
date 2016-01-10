package com.tudou.player.skin.assets
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class SymbolAsset extends DisplayObjectAsset
	{
		public function SymbolAsset(type:Class)
		{
			_type = type;
			super();
		}
		
		public function get type():Class
		{
			return _type;
		}
		
		override public function get displayObject():DisplayObject
		{
			var instance:* = new type();
			if (instance is BitmapData)
			{
				instance = new Bitmap(instance);
			}
			else if (instance is MovieClip) {
				MovieClip(instance).addEventListener(Event.ADDED_TO_STAGE, function(evt:Event):void {
					var mc:MovieClip = evt.target as MovieClip;
					mc.gotoAndPlay(1);
				})
				
			}
			return instance as DisplayObject;
		}
		private var _type:Class;
	}
}