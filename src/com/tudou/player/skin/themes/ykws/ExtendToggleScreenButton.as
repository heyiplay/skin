package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.skin.widgets.Button;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * 扩展区域切换按钮
	 * @author 8088
	 */
	public class ExtendToggleScreenButton extends Button
	{
		
		public function ExtendToggleScreenButton(normal:DisplayObject, focused:DisplayObject=null, pressed:DisplayObject=null, disabled:DisplayObject=null)
		{
			super(normal, focused, pressed, disabled);
		}
		
		override protected function onRollOut(evt:MouseEvent):void
		{
			if (!cur) updateFace(this.normal);
		}
		
		public function set cur(c:Boolean):void
		{
			if (!enabled) return;
			_cur = c;
			updateFace(_cur ? pressed : normal);
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