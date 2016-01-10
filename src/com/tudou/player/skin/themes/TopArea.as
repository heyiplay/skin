package com.tudou.player.skin.themes 
{
	import __AS3__.vec.Vector;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import com.tudou.player.skin.assets.AssetIDs;
	import com.tudou.layout.LayoutSprite;
	/**
	 * TopArea
	 */
	public class TopArea extends ControlArea
	{
		public function TopArea(widgets:Vector.<String>)
		{
			super(widgets);
			
			_id = "TopArea";
			
		}
		
		override protected function setMouseHoverRectangle():void
		{
			if (this.parent)
			{
				r_x = 0
				r_y = 0
				r_w = this.width;
				r_h = this.height + Math.max(this.parent.height * .2, 100);
			}
			
			rectangle = new Rectangle(r_x, r_y, r_w, r_h);
		}
		
		override protected function processEnabledChange():void
		{
			super.processEnabledChange();
			
			this.visible = enabled
					? (_global.status.displayState != StageDisplayState.NORMAL)? true:this.css.visible
					//? this.css.visible
					: false;
		}
		
		//OVER
	}

}