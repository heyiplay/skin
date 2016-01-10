package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.skin.widgets.Button;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	
	/**
	 * 清晰度区域按钮
	 * 
	 * @author 8088
	 */
	public class ClarityButton extends Button
	{
		
		public function ClarityButton(normal:DisplayObject, focused:DisplayObject=null, pressed:DisplayObject=null, disabled:DisplayObject=null)
		{
			super(normal, focused, pressed, disabled);
			
			labelShow = new TextField();
			labelShow.width = this.width;
			labelShow.height = 18;
			labelShow.autoSize = "center";
			//labelShow.defaultTextFormat = new TextFormat("Vandana", 11);
			labelShow.y = int((this.height-18)*.5)+1;
			labelShow.textColor = 0x000000;
			addChild(labelShow);
			
			btnLabel = new TextField();
			btnLabel.width = this.width;
			btnLabel.height = 18;
			btnLabel.autoSize = "center";
			//btnLabel.defaultTextFormat = new TextFormat("Vandana", 11);
			btnLabel.y = int((this.height-18)*.5);
			addChild(btnLabel);
		}
		
		override protected function onMouseDown(evt:MouseEvent):void
		{
			setState(PRESSED);
			updateFace(this.pressed);
		}
		
		override protected function onRollOver(evt:MouseEvent):void
		{
			setState(FOCUSED);
			updateFace(this.focused);
		}
		
		override protected function onRollOut(evt:MouseEvent):void
		{
			setState(NORMAL);
			updateFace(this.normal);
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			setState(enabled ? NORMAL : DISABLED);
		}
		
		public function set label(t:String):void
		{
			
			if (t == _label) return;
			_label = t;
			
			if (labelShow) labelShow.text = _label;
			if (btnLabel) btnLabel.text = _label;
		}
		
		public function get format():TextFormat
		{
			return label_format;
		}
		
		public function set format(f:TextFormat):void
		{
			label_format = f
			
			if (btnLabel)
			{
				btnLabel.defaultTextFormat = label_format;
				btnLabel.setTextFormat(label_format);
			}
			
			if (labelShow) 
			{
				labelShow.defaultTextFormat = label_format;
				labelShow.setTextFormat(label_format);
				labelShow.textColor = 0x000000;
			}
		}
		
		public function setState(s:String):void
		{
			var c:uint;
			switch(s)
			{
				case NORMAL:
					c = _normal;
					break;
				case FOCUSED:
					c = _focused;
					break;
				case PRESSED:
					c = _pressed;
					break;
				case DISABLED:
					c = _disabled;
					break;
			}
			if (btnLabel) btnLabel.textColor = c;
		}
		public function get vip():Boolean
		{
			return _vip;
		}
		
		public function set vip(value:Boolean):void
		{
			_vip = value;
		}
		private var labelShow:TextField;
		private var btnLabel:TextField;
		private var label_format:TextFormat;
		
		private var _normal:uint = 0x999999;
		private var _focused:uint = 0xEEEEEE;
		private var _pressed:uint = 0xEEEEEE;
		private var _disabled:uint = 0x333333;
		private var _vip:Boolean;
	}

}