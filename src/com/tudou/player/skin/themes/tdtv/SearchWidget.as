package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.widgets.TextBox;
	import com.tudou.player.skin.widgets.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author 8088
	 */
	public class SearchWidget extends Widget
	{
		
		public function SearchWidget() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			logo = _assetsManager.getDisplayObject("SearchWidgetLogo") as Sprite;
			addChild(logo);
			
			var assets_cofing:XMLList;
			search_url = configuration.@href;
			assets_cofing = configuration.textbox.(@id == "SearchWidgetTextBox");
			search_text_box = new TextBox
									( _assetsManager.getDisplayObject(assets_cofing.asset.(@state == Keyword.NORMAL).@id)
									, _assetsManager.getDisplayObject(assets_cofing.asset.(@state == Keyword.FOCUSED).@id)
									, _assetsManager.getDisplayObject(assets_cofing.asset.(@state == Keyword.PRESSED).@id)
									, _assetsManager.getDisplayObject(assets_cofing.asset.(@state == Keyword.DISABLED).@id)
									);
			search_text_box.style = assets_cofing.@style;
			search_text_box.defaultText = defaultText;
			search_text_box.defaultColor = 0xCCCCCC;
			addChild(search_text_box);
			
			assets_cofing = configuration.button.(@id == "SearchWidgetButton");
			search_btn = new Button
							( _assetsManager.getDisplayObject(assets_cofing.asset.(@state == Keyword.NORMAL).@id)
							, _assetsManager.getDisplayObject(assets_cofing.asset.(@state == Keyword.FOCUSED).@id)
							, _assetsManager.getDisplayObject(assets_cofing.asset.(@state == Keyword.PRESSED).@id)
							, _assetsManager.getDisplayObject(assets_cofing.asset.(@state == Keyword.DISABLED).@id)
							);
			search_btn.x = 250;
			search_btn.y = 2;
			addChild(search_btn);
			
			enabled = true;
		}
		
		private function focusIn(evt:FocusEvent):void
		{
			if (search_text_box.text == defaultText) search_text_box.text = "";
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:SkinNetStatusEventCode.SEARCH_FOCUS_IN, level:"status"}
				)
			);
		}
		
		private function focusOut(evt:FocusEvent):void
		{
			if (search_text_box.text == "") {
				search_text_box.text = defaultText;
			}
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:SkinNetStatusEventCode.SEARCH_FOCUS_OUT, level:"status"}
				)
			);
		}
		
		private function searchHandler(evt:MouseEvent):void
		{
			if (search_text_box.text == ""
				|| search_text_box.text == defaultText
				) 
			{
				return;
			}
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SEARCH, level:"command", data:{ url:search_url + encodeURIComponent(search_text_box.text)}}
				)
			);
		}
		
		override protected function processEnabledChange():void
		{
			search_text_box.enabled = enabled;
			search_btn.enabled = enabled;
			if (enabled)
			{
				search_text_box.textField.addEventListener(FocusEvent.FOCUS_IN, focusIn);
				search_text_box.textField.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
				search_text_box.type = TextFieldType.INPUT;
				
				search_btn.addEventListener(MouseEvent.CLICK, searchHandler);
			}
			else {
				search_text_box.textField.removeEventListener(FocusEvent.FOCUS_IN, focusIn);
				search_text_box.textField.removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
				search_text_box.type = TextFieldType.DYNAMIC;
				
				search_btn.removeEventListener(MouseEvent.CLICK, searchHandler);
			}
		}
		
		private var logo:Sprite;
		private var search_text_box:TextBox;
		private var search_btn:Button;
		private var search_url:String;
		private var defaultText:String = "搜视频";
	}

}