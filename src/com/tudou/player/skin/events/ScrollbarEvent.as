package com.tudou.player.skin.events 
{
	import flash.events.Event;

	public class ScrollbarEvent extends Event
	{		
		public static const SCOLLBAR_DRAG_START:String = "scrollbarDragStart";
		public static const SCOLLBAR_DRAG_END:String = "scrollbarDragEnd";
		
		private var _pos:Number;
		
		public function ScrollbarEvent(type:String, posNum:Number = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_pos = posNum;
			super(type, bubbles, cancelable);
		}
		
		public function get pos():Number 
		{
			return _pos;
		}
		
		public function set pos(value:Number):void 
		{
			_pos = value;
		}
	}

}