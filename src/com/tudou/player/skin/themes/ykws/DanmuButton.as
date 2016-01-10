package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Hint;
	import com.tudou.player.skin.widgets.SwitchButton;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.assets.FontAsset;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.configuration.SizeMode;
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
			btn = new SwitchButton
					( _assetsManager.getDisplayObject(open_cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(close_cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(open_cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(close_cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(open_cofing.asset.(@state == Keyword.DISABLED).@id)
					, _assetsManager.getDisplayObject(close_cofing.asset.(@state == Keyword.DISABLED).@id)
					);
			addChild(btn);
			
			var openfull_cofing:XMLList = configuration.button.(@id == "DanmuOpenButtonFull");
			var closefull_cofing:XMLList = configuration.button.(@id == "DanmuCloseButtonFull");
			
			btnfull = new SwitchButton
					( _assetsManager.getDisplayObject(openfull_cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(closefull_cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(openfull_cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(closefull_cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(openfull_cofing.asset.(@state == Keyword.DISABLED).@id)
					, _assetsManager.getDisplayObject(closefull_cofing.asset.(@state == Keyword.DISABLED).@id)
					);
			addChild(btnfull);
			
			_open_hint = open_cofing.@alt;
			_close_hint = close_cofing.@alt;
			
			loading = _assetsManager.getDisplayObject("Loading") as MovieClip;
			loading.x = int(this.width * .5);
			loading.y = int(this.height * .5 -1);
			hintColor = 0xC5C5C5;
			hintX = int(this.width * .5);
			hintY = -2;
			
			enabled = true;
			open = false;
			
			mode = SizeMode.NARROW_SCREEN;
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
			
			btnfull.enabled = enabled;
			btn.enabled = enabled;
			if (enabled)
			{
				btn.addEventListener(MouseEvent.CLICK, onClick);
				btnfull.addEventListener(MouseEvent.CLICK, onClick);
			}
			else {
				
				btn.removeEventListener(MouseEvent.CLICK, onClick);
				btnfull.removeEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		public function set open(value:Boolean):void
		{
			_open = value;
			btn.on = _open;
			btnfull.on = _open;
			if (_open) this.title = _open_hint;
			else this.title = _close_hint;
			Hint.register(this, this.title);
			if(isMouseon()) Hint.text = this.title;
		}
		
		public function get open():Boolean
		{
			return _open;
		}
		public function get mode():String
		{
			return old_set;
		}
		public function set mode(id:String):void
		{
			if (mode == id) return;
			switch(id)
			{
				case SizeMode.FULL_SCREEN:
				case SizeMode.FULL_SCREEN_INTERACTIVE:
					fullScreen = true;
					break;
				case SizeMode.NORMAL:
				case SizeMode.NARROW_SCREEN:
				case SizeMode.WIDE_SCREEN:
				case SizeMode.POPUP:
					fullScreen = false;
					break;
				default:
					throw new Error("无此尺寸设置模式：" + id);
					break;
				
			}
			
			btn.visible = !fullScreen;
			btnfull.visible = fullScreen;
		}
		//public function
		
		private var btn:SwitchButton;
		private var btnfull:SwitchButton;
		private var loading:MovieClip;
		
		private var _open:Boolean;
		private var _open_hint:String;
		private var _close_hint:String;
		private var old_set:String;
		private var fullScreen:Boolean;
	}

}