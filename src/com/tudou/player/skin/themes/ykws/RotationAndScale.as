package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.SelectBox;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import flash.events.FullScreenEvent;
	import flash.events.NetStatusEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	
	/**
	 * RotationAndScale
	 * 
	 * @author 8088
	 */
	public class RotationAndScale extends Widget
	{
		
		public function RotationAndScale()
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			var cofing:XMLList;
			
			cofing = configuration.button.(@id == "LeftRotationButton");
			left_btn = new Button
					( _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.DISABLED).@id)
					);
			left_btn.x = 2;
			left_btn.y = 2;
			addChild(left_btn);
			
			cofing = configuration.button.(@id == "RightRotationButton");
			right_btn = new Button
					( _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.DISABLED).@id)
					);
			right_btn.x = 24;
			right_btn.y = 2;
			addChild(right_btn);
			
			
			cofing = configuration.selectbox.(@id == "SizeRatioSelectBox");
			ratio_selectbox = new SelectBox
					( _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.asset.(@state == Keyword.DISABLED).@id)
					);
			ratio_selectbox.style = cofing.@style;
			ratio_selectbox.option = String(cofing.option.@list).split(",");
			ratio_selectbox.setOptionBtnStyle
					( _assetsManager.getDisplayObject(cofing.option.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.option.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.option.asset.(@state == Keyword.PRESSED).@id)
					);
			addChild(ratio_selectbox);
			
			left_btn.addEventListener(MouseEvent.CLICK, leftClickHandler);
			right_btn.addEventListener(MouseEvent.CLICK, rightClickHandler);
			ratio_selectbox.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			enabled = true;
			
		}
		
		private function leftClickHandler(evt:MouseEvent):void
		{
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_ROTATION_LEFT, level:NetStatusEventLevel.COMMAND, data:{ id:this.id}}
				)
			);
		}
		
		private function rightClickHandler(evt:MouseEvent):void
		{
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_ROTATION_RIGHT, level:NetStatusEventLevel.COMMAND, data:{ id:this.id}}
				)
			);
		}
		
		private function netStatusHandler(evt:NetStatusEvent):void
		{
			// 需要转成播放器统一的NetStatusEvent
		}
		
		override protected function processEnabledChange():void
		{
			left_btn.enabled = enabled;
			right_btn.enabled = enabled;
			ratio_selectbox.enabled = enabled;
			
			this.visible = enabled;
		}
		
		public function set ratio(r:String):void
		{
			ratio_selectbox.label = r;
		}
		
		public function get ratio():String
		{
			return ratio_selectbox.label;
		}
		
		public function set inactive(a:Boolean):void
		{
			ratio_selectbox.select = false;
		}
		
		private var left_btn:Button;
		private var right_btn:Button;
		private var ratio_selectbox:SelectBox;
	}

}