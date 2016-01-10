package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.skin.widgets.LabelButton;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * 扩展区域切换按钮
	 * @author 8088
	 */
	public class ToggleQualityExtendAreaButton extends LabelButton
	{
		
		public function ToggleQualityExtendAreaButton( label:String
									, normal:DisplayObject = null
									, focused:DisplayObject = null
									, pressed:DisplayObject = null
									, disabled:DisplayObject = null
									, normalColor:uint = 0xCCCCCC
									, focusedColor:uint = 0xFFFFFF
									, pressedColor:uint = 0xFFFFFF
									, disabledColor:uint = 0x666666
									)
		{
			super(label, normal, focused, pressed, disabled, normalColor, focusedColor, pressedColor, disabledColor);
		}
		
		override protected function onRollOut(evt:MouseEvent):void
		{
			if (!cur)
			{
				super.onRollOut(evt);
			}
		}
		
		public function get cur():Boolean
		{
			return _cur;
		}
		
		public function set cur(c:Boolean):void
		{
			if (!enabled) return;
			_cur = c;
			updateFace(_cur ? pressed : normal, _cur? pressedColor:normalColor);
			mouseEnabled = !_cur;
			buttonMode = !_cur;
		}
		public function get vip():Boolean
		{
			return _vip;
		}
		
		public function set vip(value:Boolean):void
		{
			_vip = value;
			if (normal && normal.hasOwnProperty("VipIcon")) normal["VipIcon"].visible = _vip;
			if (focused && focused.hasOwnProperty("VipIcon")) focused["VipIcon"].visible = _vip;
			if (pressed && pressed.hasOwnProperty("VipIcon")) pressed["VipIcon"].visible = _vip;
			if (disabled && disabled.hasOwnProperty("VipIcon")) disabled["VipIcon"].visible = _vip;
			
			if (value)
			{
				textField.width = this.width - 10;
				textField.x = 7;
			}
			else {
				if(this.width) textField.width = this.width;
				textField.x = 0;
			}
		}
		private var _cur:Boolean;
		private var _vip:Boolean;
	}

}