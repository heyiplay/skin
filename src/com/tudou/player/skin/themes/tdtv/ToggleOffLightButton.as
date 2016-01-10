package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.configuration.Keyword;
	import flash.events.NetStatusEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	
	/**
	 * ToggleOffLightButton
	 */
	public class ToggleOffLightButton extends Widget
	{
		
		public function ToggleOffLightButton() 
		{
			
			//this.mouseChildren = false;
			
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			var cofing:XMLList;
			
			cofing = configuration.button.(@id == "OffLightButton").asset.(hasOwnProperty("@state"));
			off_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			addChild(off_btn);
			
			cofing = configuration.button.(@id == "OnLightButton").asset.(hasOwnProperty("@state"));
			on_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			on_btn.visible = false;
			addChild(on_btn);
			
			enabled = true;
		}
		
		private function clickHandler(evt:Event):void
		{
			off = !off;
			var command_code:String = "";
			if (off) command_code = NetStatusCommandCode.OFF_LIGHT;
			else command_code = NetStatusCommandCode.ON_LIGHT;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:command_code, level:"command", data:{ id:this.id}}
				)
			);
		}
		
		public function set off(b:Boolean):void {
			if (_off == b) return;
			_off = b;
			if (on_btn) on_btn.visible = _off;
			if (off_btn) off_btn.visible = !_off;
		}
		
		public function get off():Boolean
		{
			return _off;
		}
		
		override protected function processEnabledChange():void
		{
			off_btn.enabled = enabled;
			on_btn.enabled = enabled;
			if (enabled)
			{
				off_btn.addEventListener(MouseEvent.CLICK, clickHandler);
				on_btn.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else {
				off_btn.removeEventListener(MouseEvent.CLICK, clickHandler);
				on_btn.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		
		private var off_btn:Button;
		private var on_btn:Button;
		
		private var _off:Boolean;
	}

}
