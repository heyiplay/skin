package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Label;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.assets.AssetIDs;
	import com.tudou.player.skin.assets.FontAsset;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.widgets.WidgetLoader;
	import com.tudou.player.skin.widgets.WidgetResource;
	import flash.display.MovieClip;
	import flash.events.FullScreenEvent;
	import flash.events.NetStatusEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	
	
	/**
	 * 右侧分享按钮
	 * 
	 * @author 8088
	 */
	public class RightAreaShareButton extends Widget
	{
		
		public function RightAreaShareButton()
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
			
			loading = _assetsManager.getDisplayObject("Loading") as MovieClip;
			loading.x = int(this.width * .5);
			loading.y = int(this.height * .5 -1);
			
			enabled = true;
			
		}
		
		private function clickHandler(evt:Event):void
		{
			
			enabled = false;
			btn.visible = false;
			addChild(loading);
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SHOW_SHARE_PANEL, level:NetStatusEventLevel.COMMAND, data:{ id:this.id}}
				)
			);
		}
		
		override protected function processEnabledChange():void
		{
			super.processEnabledChange();
			btn.enabled = enabled;
			if (enabled)
			{
				btn.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else {
				btn.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		
		private var btn:Button;
		private var loading:MovieClip;
	}

}