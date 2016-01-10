package com.tudou.player.skin.widgets 
{
	import com.tudou.player.skin.configuration.Keyword;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	/**
	 * 标签页按钮
	 * 
	 * @author 8088
	 */
	public class TabButton extends LabelButton
	{
		
		public function TabButton(label:String, normal:DisplayObject=null, focused:DisplayObject=null, pressed:DisplayObject=null, disabled:DisplayObject=null)
		{
			super(label, normal, focused, pressed, disabled);
			
		}
		
		override protected function onRollOut(evt:MouseEvent):void
		{
			if (!cur)
			{
				super.onRollOut(evt);
			}
		}
		
		override protected function onMouseDown(evt:MouseEvent):void
		{
			if (cur) super.onMouseDown(evt);
		}
		
		public function set cur(c:Boolean):void
		{
			if (!enabled) return;
			_cur = c;
			updateFace(_cur ? pressed : normal, _cur ? pressedColor: normalColor);
			mouseEnabled = !_cur;
			buttonMode = !_cur;
		}
		
		public function get cur():Boolean
		{
			return _cur;
		}
		
		private var _cur:Boolean;

	}

}