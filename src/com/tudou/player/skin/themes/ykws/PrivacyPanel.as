package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Label;
	import com.tudou.player.skin.widgets.LabelButton;
	import com.tudou.player.skin.widgets.TextBox;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.widgets.Hint;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	/**
	 * PrivacyPanel
	 * 
	 * @author 8088
	 */
	public class PrivacyPanel extends Widget
	{
		
		public function PrivacyPanel() 
		{
			super();
		}
		
		public function show(s:Boolean = true, info:String = ""):void
		{
			this.visible = s;
			checking = false;
			//
			if (check_info)
			{
				switch(info)
				{
					case "":
						check_info.text = info;
						break;
					case "ok":
						check_info.text = OK;
						this.visible = false;
						break;
					case "error":
						check_info.text = ERROR;
						break;
					case "timeout":
						check_info.text = TIMEOUT;
						break;
				}
			}
			//
			if (privacy_text_box)
			{
				privacy_text_box.defaultText = defaultText;
				if (enabled) privacy_text_box.type = TextFieldType.INPUT;
			}
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			bg = new PanelBg(_assetsManager.getDisplayObject("PanelBackground") as Sprite);
			bg.width = this.width;
			bg.height = this.height;
			addChild(bg);
			
			ttl = new Label();
			ttl.style = "width:156; height:22; x:20; y:24;";
			ttl.color = 0xFF8800;
			ttl.bold = true;
			ttl.size = 14;
			ttl.font = "Arial";
			addChild(ttl);
			ttl.text = "该视频已加密";
			
			var cofing:XMLList;
			
			cofing = configuration.button.(@id == "ContactUserButton");
			contact_user_url = cofing.@href;
			contact_user_btn = new Button
					( _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.DISABLED).@id)
					);
			contact_user_btn.x = 170;
			contact_user_btn.y = 24;
			contact_user_btn.hintX = 9;
			contact_user_btn.hintY = -55;
			contact_user_btn.hintV = 1;
			contact_user_btn.hintT = 1;
			this.hintY = localToGlobal(new Point(0, 0)).y;
			addChild(contact_user_btn);
			
			Hint.register(contact_user_btn, cofing.@alt);
			
			var btn_v_line:Shape = new Shape();
			btn_v_line.graphics.beginFill(0xFFFFFF, .1);
			btn_v_line.graphics.drawRect(195, 27, 1, 14);
			btn_v_line.graphics.endFill();
			addChild(btn_v_line);
			
			cofing = configuration.button.(@id == "SearchButton");
			search_url = cofing.@href;
			search_btn = new Button
					( _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.DISABLED).@id)
					);
			search_btn.x = 200;
			search_btn.y = 24;
			search_btn.hintX = 8;
			search_btn.hintY = -55;
			search_btn.hintV = 1;
			search_btn.hintT = 1;
			addChild(search_btn);
			
			Hint.register(search_btn, cofing.@alt);
			
			ttl_line = new Shape();
			ttl_line.graphics.beginFill(0xFF8800);
			ttl_line.graphics.drawRect(10, 55, bg.width-20, 1);
			ttl_line.graphics.endFill();
			addChild(ttl_line);
			
			//密码输入文本框
			cofing = configuration.textbox.(@id == "PrivacyTextBox")
			privacy_text_box = new TextBox
									( _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.NORMAL).@id)
									, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.FOCUSED).@id)
									, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.PRESSED).@id)
									, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.DISABLED).@id)
									);
			privacy_text_box.style = cofing.@style;
			privacy_text_box.defaultText = defaultText;
			privacy_text_box.defaultColor = 0x999999;
			addChild(privacy_text_box);
			
			check_info = new Label();
			check_info.style = "width:197; height:20; x:23; y:88;";
			check_info.color = 0x545454;
			check_info.align = "right";
			addChild(check_info);
			
			btm_line = new Shape();
			btm_line.graphics.beginFill(0xFFFFFF, .1);
			btm_line.graphics.drawRect(10, 111, bg.width-20, 1);
			btm_line.graphics.endFill();
			addChild(btm_line);
			
			btm_v_line = new Shape();
			btm_v_line.graphics.beginFill(0xFFFFFF, .1);
			btm_v_line.graphics.drawRect(120, 112, 1, 28);
			btm_v_line.graphics.endFill();
			addChild(btm_v_line);
			
			ok_btn = new LabelButton("确定");
			ok_btn.normalColor = 0x999999;
			ok_btn.focusedColor = 0xCCCCCC;
			ok_btn.pressedColor = 0xCCCCCC;
			ok_btn.style = "x:10; y:112; width:109; height:28;";
			ok_btn.enabled = true;
			addChild(ok_btn);
			
			cancel_btn = new LabelButton("取消");
			cancel_btn.normalColor = 0x999999;
			cancel_btn.focusedColor = 0xCCCCCC;
			cancel_btn.pressedColor = 0xCCCCCC;
			cancel_btn.style = "x:121; y:112; width:110; height:28;";
			cancel_btn.enabled = true;
			addChild(cancel_btn);
			
			cancel_btn.addEventListener(MouseEvent.CLICK, cancelHandler);
			ok_btn.addEventListener(MouseEvent.CLICK, okHandler);
			
			
			enabled = true;
		}
		
		private function cancelHandler(evt:MouseEvent):void
		{
			this.visible = false;
		}
		
		private function okHandler(evt:MouseEvent):void
		{
			if (privacy_text_box.text == ""
				|| privacy_text_box.text == defaultText
				) 
			{
				return;
			}
			checkPassworld(privacy_text_box.text);
		}
		
		/**
		 * 请求服务器验证用户输入密码
		 * 如果正确 隐藏此面板并抛出事件
		 * 如果错误 提示用户 "密码错误，请重新输入"
		 * 
		 * @param passworld:String 密码字符串
		 */
		private function checkPassworld(passworld:String):void
		{
			if (_input == passworld&&check_info.text != TIMEOUT) return;
			else _input = passworld;
			
			check_info.text = CHECKING;
			checking = true;
			if (enabled) privacy_text_box.type = TextFieldType.DYNAMIC;
			//..
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:SkinNetStatusEventCode.PRIVACY_SUBMIT_PASSWORD, level:"status", data:{password:_input}}
				)
			);
		}
		
		private function clickContactUser(evt:MouseEvent):void
		{
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:SkinNetStatusEventCode.PRIVACY_CONTACT_OWNER, level:"status", data:{url:contact_user_url}}
				)
			);
		}
		
		private function clickSearch(evt:MouseEvent):void
		{
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:SkinNetStatusEventCode.PRIVACY_SEARCH_RELATED, level:"status", data:{url:search_url}}
				)
			); 
		}
		
		private function focusIn(evt:FocusEvent):void
		{
			if (privacy_text_box.text == defaultText) privacy_text_box.text = "";
			privacy_text_box.textField.displayAsPassword = true;
			
			if(check_info.text == ERROR) check_info.text = "";
		}
		
		private function focusOut(evt:FocusEvent):void
		{
			if (privacy_text_box.text == "") {
				privacy_text_box.textField.displayAsPassword = false;
				privacy_text_box.text = defaultText;
				check_info.text = "";
			}
		}
		
		override protected function processEnabledChange():void
		{
			privacy_text_box.enabled = enabled;
			contact_user_btn.enabled = enabled;
			search_btn.enabled = enabled;
			
			if (enabled)
			{
				privacy_text_box.textField.addEventListener(FocusEvent.FOCUS_IN, focusIn);
				privacy_text_box.textField.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
				privacy_text_box.type = TextFieldType.INPUT;
				
				contact_user_btn.addEventListener(MouseEvent.CLICK, clickContactUser);
				search_btn.addEventListener(MouseEvent.CLICK, clickSearch);
			}
			else {
				privacy_text_box.textField.removeEventListener(FocusEvent.FOCUS_IN, focusIn);
				privacy_text_box.textField.removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
				privacy_text_box.type = TextFieldType.DYNAMIC;
				
				contact_user_btn.removeEventListener(MouseEvent.CLICK, clickContactUser);
				search_btn.removeEventListener(MouseEvent.CLICK, clickSearch);
			}
		}
		
		
		private var bg:PanelBg;
		private var ttl:Label;
		private var contact_user_btn:Button;
		private var contact_user_url:String;
		private var search_btn:Button;
		private var search_url:String;
		private var ttl_line:Shape;
		private var privacy_text_box:TextBox;
		private var defaultText:String = "请输入密码";
		private var check_info:Label;
		private var checking:Boolean;
		private var _input:String;
		
		private static const CHECKING:String = "验证中..";
		private static const OK:String = "密码正确";
		private static const ERROR:String = "密码错误，请重新输入";
		private static const TIMEOUT:String = "检验超时，请稍后再试";
		
		private var btm_line:Shape;
		private var btm_v_line:Shape;
		
		private var cancel_btn:LabelButton;
		private var ok_btn:LabelButton;
		
	}

}