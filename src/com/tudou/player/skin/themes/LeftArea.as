package com.tudou.player.skin.themes 
{
	import __AS3__.vec.Vector;
	import com.tudou.player.skin.assets.AssetIDs;
	import com.tudou.layout.LayoutSprite;
	/**
	 * LeftArea
	 */
	public class LeftArea extends ControlArea
	{
		public function LeftArea(widgets:Vector.<String>)
		{
			super(widgets);
			
			_id = "LeftArea";
		}
		
		override public function set hide(h:Boolean):void
		{
			if (!enabled) return;
			
			super.hide = h;
		}
		
		override public function set enabled(value:Boolean):void
		{ 
			super.enabled = value;
			super.visible = value;
		}
		
		//OVER
	}
}