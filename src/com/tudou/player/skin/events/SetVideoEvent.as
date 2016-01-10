package com.tudou.player.skin.events 
{
	import flash.events.Event;
	
	/**
	 * SetVideoEvent
	 */
	public class SetVideoEvent extends Event 
	{
		public static const SET_VIDEO_STATUS:String = "setVideoStatus";
		public var _status:String;
		public function SetVideoEvent(type:String, status:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_status = status;
		} 
		
		public override function clone():Event 
		{ 
			return new SetVideoEvent(type, _status, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SetVideoEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}