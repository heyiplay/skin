package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.skin.widgets.Widget;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author 8088
	 */
	public class BufferLoadWidget extends Widget
	{
		
		public function BufferLoadWidget() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			this.mouseEnabled = false;
			this.enabled = false;
			loading = _assetsManager.getDisplayObject("BufferLoading") as MovieClip;
			addChild(loading);
		}
		
		private var loading:MovieClip;
	}

}