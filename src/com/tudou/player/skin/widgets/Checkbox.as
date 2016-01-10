package com.tudou.player.skin.widgets 
{
	import com.tudou.layout.LayoutSprite;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * 复选按钮
	 * 
	 * @author 8088
	 */
	public class Checkbox extends RadioButton
	{
		public function Checkbox( label:String
								, normal:DisplayObject
								, check_normal:DisplayObject
								, focused:DisplayObject = null
								, check_focused:DisplayObject = null
								, disabled:DisplayObject = null
								, check_disabled:DisplayObject = null
								)
		{
			super(label, normal, check_normal, focused, check_focused, disabled, check_disabled);
		}
		
		override protected function onMouseDown(evt:MouseEvent):void
		{
			_check = !_check;
			if (_check)
			{
				updateFace(check_focused, focusedColor);
			}
			else {
				updateFace(focused, focusedColor);
			}
			
		}
		
		override public function set check(b:Boolean):void
		{
			this._check = b;
			
			if (_check)
			{
				if (enabled)
				{
					if(_mouse_on) updateFace(check_focused, focusedColor);
					else updateFace(check_normal, normalColor);
				}
				else updateFace(check_disabled, disabledColor);
			}
			else {
				if(enabled) updateFace(normal, normalColor);
				else updateFace(disabled, disabledColor);
			}
			
		}
		
		override protected function onRollOut(evt:MouseEvent):void
		{
			var btn_face:DisplayObject;
			var btn_color:uint;
			
			if (check)
			{
				btn_face = check_normal;
			}
			else {
				btn_face = normal;
			}
			
			updateFace(btn_face, normalColor);
			
			_mouse_on = false;
		}
		
	}

}