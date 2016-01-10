package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Label;
	import com.tudou.player.skin.widgets.LabelButton;
	import com.tudou.player.skin.widgets.Widget;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	/**
	 * ErrorPanel
	 * 
	 * @author 8088
	 */
	public class ErrorPanel extends Widget
	{
		
		public function ErrorPanel() 
		{
			super();
		}
		
		public function showError(err_code:String, err_message:String):void
		{
			this.visible = true;
			var str:String  = _global.language.getString(err_code, NetStatusEventLevel.ERROR );
			if (str == "" || str == "非常抱歉，检测到未知错误，请尝试刷新或联系客服。") str = err_message;
			msg.htmlText =  "<font face='" + panel_font + "' color='#EBEBEB' size='13'>" + str +" (" + err_code + ")</font>";
			resize();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			bg = _assetsManager.getDisplayObject("ErrorPanelBackground") as Sprite;
			bg.width = this.width;
			bg.height = this.height;
			addChild(bg);
			
			icon = _assetsManager.getDisplayObject("ErrorPanelImage") as Sprite;
			icon.x = 24;
			icon.y = 30;
			addChild(icon);
			
			var cofing:XMLList = configuration.button.(@id == "CloseButton").asset.(hasOwnProperty("@state"));
			close_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			close_btn.x = this.width - close_btn.width - 2;
			close_btn.y = 5;
			close_btn.enabled = true;
			addChild(close_btn);
			
			ttl = new Label();
			ttl.color = 0x818181;
			ttl.size = 21;
			ttl.font = panel_font;
			ttl.text = "十分抱歉~~";
			ttl.style = "position:relative; width:120; height:30; left:103; top:34;";
			addChild(ttl);
			
			msg = new Label();
			msg.style = "width:100%-120; height:100%-100; left:105; top:65; position:relative;";
			msg.multiline = true;
			msg.color = 0xEBEBEB;
			msg.size = 13;
			msg.font = panel_font;
			addChild(msg);
			
			
			refresh_btn = new LabelButton("尝试刷新");
			refresh_btn.normalColor = 0xFF612A;
			refresh_btn.focusedColor = 0xFF612A;
			refresh_btn.pressedColor = 0xFF612A;
			var tf:TextFormat = refresh_btn.textField.defaultTextFormat;
			tf.underline = true;
			tf.font = panel_font;
			refresh_btn.textField.defaultTextFormat = tf;
			refresh_btn.style = "position:relative; bottom:15; right:21; width:54; height:20;";
			addChild(refresh_btn);
			
			enabled = true;
		}
		private function onLinkEvent(e:TextEvent):void {
			switch( e.text ) {
				case "refresh":
					refreshHandler();
				break;
			}
		}
		private function closeHandler(evt:MouseEvent):void
		{
			this.visible = false;
		}
		
		private function refreshHandler(evt:MouseEvent = null):void
		{
			if(_global.system.pageUrl) navigateToUrl(new URLRequest(_global.system.pageUrl), "_self");
		}
		
		private function resize():void
		{
			var h:Number = msg.textField.textHeight + 115;
			this.style = "height:" + Math.max(151, h) + ";"
			
			bg.width = this.width;
			bg.height = this.height;
		}
		override protected function processEnabledChange():void
		{
			refresh_btn.enabled = enabled;
			close_btn.enabled = enabled;
			if (enabled)
			{
				refresh_btn.addEventListener(MouseEvent.CLICK, refreshHandler);
				close_btn.addEventListener(MouseEvent.CLICK, closeHandler);
				msg.addEventListener(TextEvent.LINK , onLinkEvent );
			}
			else {
				refresh_btn.removeEventListener(MouseEvent.CLICK, refreshHandler);
				close_btn.removeEventListener(MouseEvent.CLICK, closeHandler);
				msg.removeEventListener(TextEvent.LINK , onLinkEvent );
			}
		}
		private var bg:Sprite;
		private var icon:Sprite;
		private var ttl:Label;
		private var msg:Label;
		private var panel_font:String = "Microsoft YaHei,微软雅黑,Arial,Verdana,_sans";
		private var refresh_btn:LabelButton;
		private var close_btn:Button;
	}
}