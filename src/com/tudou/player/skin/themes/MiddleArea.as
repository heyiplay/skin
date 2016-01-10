package com.tudou.player.skin.themes 
{
	import __AS3__.vec.Vector;
	import flash.display.StageDisplayState;
	import com.tudou.player.skin.assets.AssetIDs;
	import com.tudou.layout.LayoutSprite;
	import flash.events.Event;
	/**
	 * MiddleArea
	 */
	public class MiddleArea extends ControlArea
	{
		public function MiddleArea(widgets:Vector.<String>)
		{
			super(widgets);
			
			_id = "MiddleArea";
			
		}
		
		override protected function mouseMove(evt:Event):void
		{
			return;
		}
		
		override protected function mouseLeve(evt:Event):void
		{
			return;
		}
		
		override public function set hide(h:Boolean):void
		{
			_hide = true;
		}
		
		override public function onSizeModeChange(mode:String):void
		{
			return;
		}
		
		//OVER
	}

}