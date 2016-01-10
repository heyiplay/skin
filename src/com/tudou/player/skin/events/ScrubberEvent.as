package com.tudou.player.skin.events
{
	import flash.events.Event;

	public class ScrubberEvent extends Event
	{
		public static const SCRUB_START:String = "scrubStart";
		public static const SCRUB_UPDATE:String = "scrubUpdate";
		public static const SCRUB_END:String = "scrubEnd";
		
		public static const SCRUB_DRAG_START:String = "scrubDragStart";
		public static const SCRUB_DRAG_END:String = "scrubDragEnd";
		public static const SCRUB_CLICK:String = "scrubClick";
		
		private var _pos:Number;
		
		public function ScrubberEvent(type:String, posNum:Number = 0, bubbles:Boolean=false, cancelable:Boolean=false)
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