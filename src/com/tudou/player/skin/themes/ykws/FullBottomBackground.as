package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.widgets.Widget;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	/**
	 * FullBottomBackground
	 * 
	 * @author 8088
	 */
	public class FullBottomBackground extends Widget
	{
		
		public function FullBottomBackground() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			//enabled = true;
		}
		override protected function reSetWidth():void
		{
			if (_global.status.displayState != StageDisplayState.NORMAL)
			{
				this.visible = true;
			}else {
				this.visible = false;
			}
		}
	}

}