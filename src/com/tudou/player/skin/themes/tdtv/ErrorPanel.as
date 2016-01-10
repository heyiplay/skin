package com.tudou.player.skin.themes.tdtv 
{
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
	import flash.geom.Rectangle;
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
			msg.htmlText = "<textformat leading='5'>" + err_message +" #" + err_code + "</textformat>";
			
			resize()
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			bg = new PanelBg(_assetsManager.getDisplayObject("PanelBackground") as Sprite);
			bg.width = this.width;
			bg.height = this.height;
			addChild(bg);
			
			icon = _assetsManager.getDisplayObject("ErrorPanelIcon") as Sprite;
			icon.x = 22;
			icon.y = 21;
			addChild(icon);
			
			ttl = new Label();
			ttl.style = "width:165; height:30; x:55; y:22;";
			ttl.color = 0xCCCCCC;
			ttl.bold = true;
			ttl.size = 18;
			ttl.font = "Arial";
			ttl.text = "Sorry!";
			addChild(ttl);
			
			ttl_line = new Shape();
			ttl_line.graphics.beginFill(0x363636);
			ttl_line.graphics.drawRect(10, 55, bg.width-20, 1);
			ttl_line.graphics.endFill();
			addChild(ttl_line);
			
			msg = new Label();
			msg.style = "width:100%-40; height:100%-80; left:20; top:63; position:relative;";
			msg.multiline = true;
			msg.color = 0x999999;
			addChild(msg);
			/*
			btm_line = new Shape();
			btm_line.graphics.beginFill(0xFFFFFF, .1);
			btm_line.graphics.drawRect(10, 141, bg.width-20, 1);
			btm_line.graphics.endFill();
			addChild(btm_line);
			*/
			ok_btn = new LabelButton("关闭");
			ok_btn.normalColor = 0x999999;
			ok_btn.focusedColor = 0xCCCCCC;
			ok_btn.pressedColor = 0xCCCCCC;
			ok_btn.style = "right:0; bottom:15; width:80; height:28; position:relative;";
			ok_btn.enabled = true;
			ok_btn.addEventListener(MouseEvent.CLICK, okHandler);
			addChild(ok_btn);
			
			/*
			btm_v_line = new Shape();
			btm_v_line.graphics.beginFill(0xFFFFFF, .1);
			btm_v_line.graphics.drawRect(120, 112, 1, 28);
			btm_v_line.graphics.endFill();
			addChild(btm_v_line);
			
			cancel_btn = new LabelButton("取消");
			cancel_btn.normalColor = 0x999999;
			cancel_btn.focusedColor = 0xCCCCCC;
			cancel_btn.pressedColor = 0xCCCCCC;
			cancel_btn.style = "x:121; y:112; width:110; height:28;";
			cancel_btn.enabled = true;
			addChild(cancel_btn);
			
			cancel_btn.addEventListener(MouseEvent.CLICK, cancelHandler);
			*/
		}
		
		private function cancelHandler(evt:MouseEvent):void
		{
			this.visible = false;
		}
		
		private function okHandler(evt:MouseEvent):void
		{
			this.visible = false;
		}
		
		private function resize():void
		{
			this.style = "width:" + Math.max(240, msg.text.length * 3.3) +"; height:" + Math.max(150, msg.text.length * 2.2) + ";"
			
			bg.width = this.width;
			bg.height = this.height;
			
			ttl_line.graphics.clear();
			ttl_line.graphics.beginFill(0x363636);
			ttl_line.graphics.drawRect(10, 55, bg.width-20, 1);
			ttl_line.graphics.endFill();
		}
		
		private var bg:PanelBg;
		private var icon:Sprite;
		private var ttl:Label;
		private var ttl_line:Shape;
		private var btm_line:Shape;
		private var btm_v_line:Shape;
		private var msg:Label;
		
		private var cancel_btn:LabelButton;
		private var ok_btn:LabelButton;
		
	}

}