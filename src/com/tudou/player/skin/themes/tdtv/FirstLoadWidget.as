package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.skin.widgets.Widget;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * FirstLoadWidget
	 * 
	 * @author 8088
	 */
	public class FirstLoadWidget extends Widget
	{
		
		public function FirstLoadWidget() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			logo = _assetsManager.getDisplayObject("FirstLoadLogo") as Sprite;
			logo.x = int((this.width-logo.width) * .5);
			logo.y = int((this.height-logo.height) * .5);
			addChild(logo);
			
		}
		
		override protected function reSetWidth():void
		{
			if (logo) logo.x = int((this.width-logo.width) * .5);
		}
		
		override protected function reSetHeight():void
		{
			if (logo) logo.y = int((this.height-logo.height) * .5);
		}
		
		
		private var bg:Sprite;
		private var logo:Sprite;
	}

}