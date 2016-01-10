package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Widget;
	import flash.events.NetStatusEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	
	/**
	 * TogglePauseButton
	 */
	public class TogglePauseButton extends Widget
	{
		
		public function TogglePauseButton() 
		{
			
			//this.mouseChildren = false;
			
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			var cofing:XMLList;
			
			cofing = configuration.button.(@id == "PauseButton").asset.(hasOwnProperty("@state"));
			pause_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			addChild(pause_btn);
			
			cofing = configuration.button.(@id == "PlayButton").asset.(hasOwnProperty("@state"));
			play_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			play_btn.visible = false;
			addChild(play_btn);
			
			enabled = true;
		}
		
		private function clickHandler(evt:Event):void
		{
			pause = !pause;
			var status:String;
			if (pause) status = NetStatusCommandCode.PAUSE;
			else status = NetStatusCommandCode.PLAY;
			dispatchEvent(new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:status, level:NetStatusEventLevel.COMMAND, data:{id:this.id, action:MouseEvent.CLICK} }
							)
						 );
		}
		
		public function set pause(b:Boolean):void
		{
			if (_pause == b) return;
			_pause = b;
			if (play_btn) play_btn.visible = _pause;
			if (pause_btn) pause_btn.visible = !_pause;
		}
		
		public function get pause():Boolean
		{
			return _pause;
		}
		
		override protected function processEnabledChange():void
		{
			if (enabled)
			{
				pause_btn.enabled = true;
				pause_btn.addEventListener(MouseEvent.CLICK, clickHandler);
				play_btn.enabled = true;
				play_btn.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else {
				pause_btn.enabled = false;
				pause_btn.removeEventListener(MouseEvent.CLICK, clickHandler);
				play_btn.enabled = false;
				play_btn.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		
		private var pause_btn:Button;
		private var play_btn:Button;
		
		private var _pause:Boolean;
	}

}
