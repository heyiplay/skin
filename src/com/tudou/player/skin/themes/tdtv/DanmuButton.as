package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Hint;
	import com.tudou.player.skin.widgets.ToggleButton;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.assets.FontAsset;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.widgets.WidgetLoader;
	import com.tudou.player.skin.widgets.WidgetResource;
	import flash.events.NetStatusEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	/**
	 * RelatedButton
	 * 
	 * @author 8088
	 */
	public class DanmuButton extends Widget
	{
		
		public function DanmuButton() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			var open_cofing:XMLList = configuration.button.(@id == "DanmuOpenButton");
			var close_cofing:XMLList = configuration.button.(@id == "DanmuCloseButton");
			btn = new ToggleButton
					( _assetsManager.getDisplayObject(open_cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(close_cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(open_cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(close_cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(open_cofing.asset.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(close_cofing.asset.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(open_cofing.asset.(@state == Keyword.DISABLED).@id)
					, _assetsManager.getDisplayObject(close_cofing.asset.(@state == Keyword.DISABLED).@id)
					);
			addChild(btn);
			
			_open_hint = open_cofing.@alt;
			_close_hint = close_cofing.@alt;
			
			loading = _assetsManager.getDisplayObject("Loading") as MovieClip;
			loading.x = int(this.width * .5);
			loading.y = int(this.height * .5 -1);
			
			hintX = int(this.width * .5);
			hintY = -2;
			
			enabled = true;
			open = false;
		}
		
		private function onClick(evt:MouseEvent):void
		{
			/*if (!open)
			{
				enabled = false;
				btn.visible = false;
				addChild(loading);
			}
			*/
			open = !open;
			
			var status:String;
			if (open) status = NetStatusCommandCode.OPEN_DANMU;
			else status = NetStatusCommandCode.CLOSE_DANMU;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:status, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, action:evt.type } }
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
		
		public function set open(value:Boolean):void
		{
			_open = value;
			btn.toggle = _open;
			
			if (_open) this.title = _open_hint;
			else this.title = _close_hint;
			Hint.register(this, this.title);
			if(isMouseon()) Hint.text = this.title;
		}
		
		public function get open():Boolean
		{
			return _open;
		}
		
		//public function
		
		private var btn:ToggleButton;
		private var loading:MovieClip;
		
		private var _open:Boolean;
		private var _open_hint:String;
		private var _close_hint:String;
	}

}