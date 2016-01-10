package com.tudou.player.skin.widgets 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 8088
	 */
	public class SelectBoxList extends LabelButton
	{
		
		public function SelectBoxList(label:String, normal:DisplayObject=null, focused:DisplayObject=null, pressed:DisplayObject=null, disabled:DisplayObject=null) 
		{
			super(label, normal, focused, pressed, disabled);
		}
		
		public function set cur(c:Boolean):void
		{
			if (!enabled) return;
			_cur = c;
			updateFace(_cur ? focused : normal, _cur ? focusedColor : normalColor);
			
		}
		
		public function get cur():Boolean
		{
			return _cur;
		}
		
		private var _cur:Boolean;
	}

}