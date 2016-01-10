package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.layout.LayoutSprite;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Hint;
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
			if (configuration && configuration.extendarea.length()>0)
			{
				initExtendArea();
			}
			var cofing:XMLList;
			
			cofing = configuration.button.(@id == "PauseButton").asset.(hasOwnProperty("@state"));
			pause_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			addChild(pause_btn);
			
			_pause_hint = configuration.button.(@id == "PauseButton").@alt;
			
			cofing = configuration.button.(@id == "PlayButton").asset.(hasOwnProperty("@state"));
			play_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			play_btn.visible = false;
			addChild(play_btn);
			
			_play_hint = configuration.button.(@id == "PlayButton").@alt;
			hintX = int(pause_btn.width * .5);
			hintY = -2;
			hintColor = 0xC5C5C5;
			
			enabled = true;
			pause = false;
			
		}
		private function initExtendArea():void
		{
			extendArea = new LayoutSprite();
			extendArea.style = configuration.extendarea.@style;
			addChild(extendArea);
			_animal_play_mc = _assetsManager.getDisplayObject("TogglePlayAnimation") as MovieClip;
			_animal_play_mc.visible = false;
			_animal_pause_mc = _assetsManager.getDisplayObject("TogglePauseAnimation") as MovieClip;
			extendArea.addChild(_animal_play_mc);
			extendArea.addChild(_animal_pause_mc);
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
			if (b) this.title = _play_hint;
			else this.title = _pause_hint;
			Hint.register(this, this.title);
			if (isMouseon() && enabled) Hint.text = this.title;
			
			if (_pause == b) return;
			_pause = b;
			
			if (play_btn) play_btn.visible = _pause;
			if (pause_btn) pause_btn.visible = !_pause;
			if (_animal_play_mc)
			{
				_animal_play_mc.gotoAndPlay(1);
				_animal_play_mc.visible = _pause;
			}
			if (_animal_pause_mc)
			{
				_animal_pause_mc.gotoAndPlay(1);
				_animal_pause_mc.visible = !_pause;
			}
		}
		
		public function get pause():Boolean
		{
			return _pause;
		}
		
		override protected function processEnabledChange():void
		{
			super.processEnabledChange();
			
			pause_btn.enabled = enabled;
			play_btn.enabled = enabled;
			_animal_play_mc.mouseEnabled = enabled;
			_animal_pause_mc.mouseEnabled = enabled;
			if (enabled)
			{
				pause_btn.addEventListener(MouseEvent.CLICK, clickHandler);
				play_btn.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else {
				pause_btn.removeEventListener(MouseEvent.CLICK, clickHandler);
				play_btn.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		
		private var pause_btn:Button;
		private var play_btn:Button;
		
		private var _pause:Boolean;
		private var _animal_play_mc:MovieClip;
		private var _animal_pause_mc:MovieClip;
		private var extendArea:LayoutSprite;
		
		private var _pause_hint:String;
		private var _play_hint:String;
	}

}
