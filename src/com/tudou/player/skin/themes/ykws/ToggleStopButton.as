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
	 * ToggleStopButton
	 */
	public class ToggleStopButton extends Widget
	{
		
		public function ToggleStopButton() 
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
			
			cofing = configuration.button.(@id == "StopButton").asset.(hasOwnProperty("@state"));
			stop_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			addChild(stop_btn);
			
			_stop_hint = configuration.button.(@id == "StopButton").@alt;
			
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
			hintX = int(stop_btn.width * .5);
			hintY = -2;
			hintColor = 0xC5C5C5;
			
			enabled = true;
			stop = false;
		}
		private function initExtendArea():void
		{
			extendArea = new LayoutSprite();
			extendArea.style = configuration.extendarea.@style;
			addChild(extendArea);
			_animal_play_mc = _assetsManager.getDisplayObject("TogglePlayAnimation") as MovieClip;
			_animal_play_mc.visible = false;
			_animal_stop_mc = _assetsManager.getDisplayObject("TogglePauseAnimation") as MovieClip;
			extendArea.addChild(_animal_play_mc);
			extendArea.addChild(_animal_stop_mc);
		}
		private function clickHandler(evt:Event):void
		{
			stop = !stop;
			var status:String;
			
			if (stop) status = NetStatusCommandCode.STOP;
			else status = NetStatusCommandCode.PLAY;
			dispatchEvent(new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:status, level:NetStatusEventLevel.COMMAND, data:{id:this.id, action:MouseEvent.CLICK} }
							)
						 );
		}
		
		public function set stop(b:Boolean):void
		{
			
			if (b) this.title = _play_hint;
			else this.title = _stop_hint;
			Hint.register(this, this.title);
			if (isMouseon() && enabled) Hint.text = this.title;
			
			if (_stop == b) return;
			_stop = b;
			
			if (play_btn) play_btn.visible = _stop;
			if (stop_btn) stop_btn.visible = !_stop;
			if (_animal_play_mc)
			{
				_animal_play_mc.gotoAndPlay(1);
				_animal_play_mc.visible = _stop;
			}
			if (_animal_stop_mc)
			{
				_animal_stop_mc.gotoAndPlay(1);
				_animal_stop_mc.visible = !_stop;
			}
		}
		
		public function get stop():Boolean
		{
			return _stop;
		}
		
		override protected function processEnabledChange():void
		{
			super.processEnabledChange();
			
			stop_btn.enabled = enabled;
			play_btn.enabled = enabled;
			_animal_play_mc.mouseEnabled = enabled;
			_animal_stop_mc.mouseEnabled = enabled;
			if (enabled)
			{
				stop_btn.addEventListener(MouseEvent.CLICK, clickHandler);
				play_btn.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else {
				stop_btn.removeEventListener(MouseEvent.CLICK, clickHandler);
				play_btn.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		
		
		private var stop_btn:Button;
		private var play_btn:Button;
		
		private var _stop:Boolean;
		private var _animal_play_mc:MovieClip;
		private var _animal_stop_mc:MovieClip;
		private var extendArea:LayoutSprite;
		
		private var _stop_hint:String;
		private var _play_hint:String;
	}

}
