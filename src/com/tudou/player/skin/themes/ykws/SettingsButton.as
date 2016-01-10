package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.assets.FontAsset;
	import com.tudou.player.skin.configuration.Keyword;
	import flash.display.MovieClip;
	import flash.events.NetStatusEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	/**
	 * SettingsButton
	 * 
	 * @author 8088
	 */
	public class SettingsButton extends Widget
	{
		
		public function SettingsButton() 
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
		
		private function onClick(evt:MouseEvent):void
		{
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.TOGGLE_HIDE_SHOW_SET_PANEL, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, action:MouseEvent.CLICK, tab:default_tab } }
				)
			);
		}
		
		override protected function processEnabledChange():void
		{
			super.processEnabledChange();
			if (enabled)
			{
				btn.enabled = true;
				btn.addEventListener(MouseEvent.CLICK, onClick);
			}
			else {
				btn.enabled = false;
				btn.removeEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		private var btn:Button;
		private var default_tab:String = "色彩";
	}

}