package com.tudou.player.skin.themes 
{
	import __AS3__.vec.Vector;
	import com.tudou.player.skin.configuration.ListType;
	import com.tudou.player.skin.themes.ControlArea;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageDisplayState;
	import flash.geom.Rectangle;
	
	import com.tudou.player.skin.assets.AssetIDs;
	import com.tudou.layout.LayoutSprite;
	/**
	 * RightArea
	 */
	public class RightArea extends ControlArea
	{
		public function RightArea(widgets:Vector.<String>)
		{
			super(widgets);
			
			_id = "RightArea";
		}
		
		override protected function setMouseHoverRectangle():void
		{
			
			if (this.parent)
			{
				r_x = Math.min(-this.parent.width * .2, -100);
				r_y = Math.min( -(this.parent.height - this.height) * .3, 0);
				r_w = this.width;
				r_h = Math.max((this.parent.height - this.height) * .5, this.height);
			}
			
			rectangle = new Rectangle(r_x, r_y, r_w, r_h);
		}
		/*
		override public function set hide(h:Boolean):void
		{
			if (!enabled) return;
			
			super.hide = h;
		}
		*/
		/*override public function set enabled(value:Boolean):void
		{ 
			super.enabled = value;
			super.visible = value;
		}
		*/
		
		
		//OVER
	}
}