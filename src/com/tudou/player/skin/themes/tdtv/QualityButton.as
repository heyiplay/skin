package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.skin.widgets.LabelButton;
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
	public class QualityButton extends LabelButton
	{
		
		public function QualityButton( label:String
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
				textField.x = 9;
			}
			else {
				if(this.width) textField.width = this.width;
				textField.x = 0;
			}
		}
		
		private var _vip:Boolean;
		
	}

}