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
	import flash.events.FullScreenEvent;
	import flash.events.NetStatusEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	
	/**
	 * RightAreaCommentButton
	 * 
	 * @author 8088
	 */
	public class RightAreaCommentButton extends Widget
	{
		
		public function RightAreaCommentButton()
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
			
			enabled = true;
			
		}
		
		private function clickHandler(evt:Event):void
		{
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.GOTO_TUDOU_COMMENT, level:NetStatusEventLevel.COMMAND, data:{ id:this.id}}
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
	}

}