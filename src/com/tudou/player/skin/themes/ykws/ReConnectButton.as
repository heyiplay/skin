package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.events.NetStatusEventLevel;
	
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.configuration.Keyword;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	
	/**
	 * ReConnectButton
	 * 
	 * @author 8088
	 */
	public class ReConnectButton extends Widget
	{
		
		public function ReConnectButton() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			var cofing:XMLList = configuration.asset.(hasOwnProperty("@state"));
			btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			addChild(btn);
			hintX = int(this.width * .5);
			hintY = -2;
			hintColor = 0xC5C5C5;
			
			enabled = true;
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			dispatchEvent(new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:NetStatusCommandCode.RECONNECT, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, action:evt.type }}
							)
						 );
		}
		
		override protected function processEnabledChange():void
		{
			super.processEnabledChange();
			if (enabled)
			{
				btn.enabled = true;
				btn.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else {
				btn.enabled = false;
				btn.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		
		private var btn:Button;
	}

}