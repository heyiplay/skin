package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.utils.Tween;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.assets.AssetIDs;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	/**
	 * LargePlayButton
	 */
	public class LargeButton extends Widget
	{
		
		public function LargeButton() 
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public function set pause(b:Boolean):void {
			if (_pause == b) return;
			_pause = b;
			if (_pause) btn_mc.gotoAndStop(1);
			else  btn_mc.gotoAndStop(2);
			
			if(enabled) show();
		}
		
		private function show():void
		{
			tween.easeOut().from( {scaleX:1, scaleY:1, alpha:1 } ).to( {scaleX:2, scaleY:2, alpha:0 }, 600);
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			btn_mc = _assetsManager.getDisplayObject("LargeButtonMc") as MovieClip;
			btn_mc.x = 30;
			btn_mc.y = 30;
			addChild(btn_mc);
			
			tween = new Tween(btn_mc);
			tween.to( { alpha:0 } );
			enabled = false;
		}
		
		override protected function processEnabledChange():void
		{
			this.visible = enabled;
		}
		
		private var btn_mc:MovieClip;
		private var _pause:Boolean;
		private var tween:Tween;
	}

}