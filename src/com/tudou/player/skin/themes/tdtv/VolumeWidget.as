package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.events.SchedulerEvent;
	import com.tudou.events.TweenEvent;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.assets.AssetIDs;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.widgets.HasBgImgLayoutSprite;
	import com.tudou.utils.Check;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.utils.Scheduler;
	import com.tudou.utils.Tween;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	/**
	 * VolumeWidget
	 * 
	 * @author 8088
	 */
	public class VolumeWidget extends Widget
	{
		
		public function VolumeWidget() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			if (configuration && configuration.extendarea.length()>0)
			{
				initExtendArea();
			}
			
			var cofing:XMLList = configuration.asset.(hasOwnProperty("@state"));
			btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			addChild(btn);
			
			stepped = _assetsManager.getDisplayObject(AssetIDs.VOLUME_BUTTON_STEPPED) as MovieClip;
			btn.addChild(stepped);
			
			trackTimer = new Timer(UPDATE_INTERVAL);
			trackTimer.addEventListener(TimerEvent.TIMER, onTrackTimer);
			
			enabled = true;
			
			//fix step view bug
			Scheduler.setTimeout(1, function(evt:SchedulerEvent):void { updateStepped(volume); } );
			
		}
		
		private function initExtendArea():void
		{
			extendArea = new HasBgImgLayoutSprite();
			extendArea.style = configuration.extendarea.@style;
			extendArea.mouseChildren = false;
			extendArea.mouseEnabled = true;
			extendArea.buttonMode = true;
			addChild(extendArea);
			
			rectangle = new Rectangle(0, -10, this.width, extendArea.height +this.height);
			
			tween = new Tween(extendArea);
			
			
			volumeControlMask = _assetsManager.getDisplayObject(AssetIDs.VOLUME_CONTROL_AREA_MASK) as Sprite;
			
			scrubTrack = _assetsManager.getDisplayObject(AssetIDs.VOLUME_CONTROL_AREA_TRACK) as Sprite;
			
			scrubTrack.y = volumeControlMask.height+8;
			extendArea.addChild(scrubTrack);
			extendArea.addChild(volumeControlMask);
			scrubTrack.mask = volumeControlMask;
			
		}
		
		private var last_volume:Number = _default_volume;
		private function downHandler(evt:MouseEvent):void
		{
			mute = !mute;
			
			var v:Number;
			if (mute)
			{
				last_volume = _volume;
				v = 0.0;
			}
			else {
				if (last_volume < _min_volume)
				{
					v = _default_volume
				}
				else {
					v = last_volume;
				}
			}
			
			setVolume(v);
			
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:NetStatusCommandCode.SET_VOLUME, level:NetStatusEventLevel.COMMAND, data:{value:_volume, id:this.id, action:evt.type} }
							)
						 );
			_old_volume = _volume;
		}
		
		private function onExtendAreaMouseDown(evt:MouseEvent):void
		{
			extendArea.addEventListener(MouseEvent.MOUSE_MOVE, controlVolume);
			extendArea.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (stage) stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
			controlVolume();
			
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:NetStatusCommandCode.SET_VOLUME, level:NetStatusEventLevel.COMMAND, data:{value:_volume, id:this.id, action:evt.type} }
							)
						 );
						 
			_old_volume = _volume;
			
			trackTimer.reset();
			trackTimer.start();
		}
		
		private function removeMouseEvent(evt:MouseEvent = null):void
		{
			extendArea.removeEventListener(MouseEvent.MOUSE_MOVE, controlVolume);
			extendArea.removeEventListener(MouseEvent.MOUSE_UP, removeMouseEvent);
			if (stage) stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
			trackTimer.stop();
		}
		
		private function onTrackTimer(evt:TimerEvent = null):void
		{
			
			if (_volume == _old_volume) return;
			
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:NetStatusCommandCode.SET_VOLUME, level:NetStatusEventLevel.COMMAND, data:{value:_volume, id:this.id, action:MouseEvent.MOUSE_MOVE} }
							)
						 );
						 
		}
		
		private function onMouseUp(evt:MouseEvent):void
		{
			removeMouseEvent();
			
			if (_volume == _old_volume) return;
			
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:NetStatusCommandCode.SET_VOLUME, level:NetStatusEventLevel.COMMAND, data:{value:_volume, id:this.id, action:evt.type} }
							)
						 );
						 
			_old_volume = _volume;			 
		}
		
		private function onStageMouseUp(evt:MouseEvent):void
		{
			removeMouseEvent();
			
			if (_volume == _old_volume) return;
			
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:NetStatusCommandCode.SET_VOLUME, level:NetStatusEventLevel.COMMAND, data:{value:_volume, id:this.id, action:evt.type} }
							)
						 );
						 
			_old_volume = _volume;
		}
		
		private function controlVolume(evt:Event = null):void
		{
			var v:Number = (volumeControlMask.height - (extendArea.mouseY - 8)) / volumeControlMask.height;
			if (v < _min_volume) 
			{
				mute = true;
				v = 0;
			}
			else {
				mute = false;
			}
			
			setVolume(v);
			
		}
		
		private function show():void
		{
			tween.pause();
			tween.easeOut().fadeIn(300);
		}
		
		private function hidden():void
		{
			tween.pause();
			tween.fadeOut(200);
		}
		
		private var on_mouse_out:Boolean;
		private function onMouseOver(evt:MouseEvent):void
		{
			on_mouse_out = false;
			
			if (mouseY < 5)
			{
				if(!btn.hasEventListener(MouseEvent.MOUSE_MOVE)) btn.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				return;
			}
			else {
				//启动延时
				startTimer();
			}
		}
		
		private function onMouseMove(evt:MouseEvent):void
		{
			if (mouseY >= 5)
			{
				btn.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				
				startTimer();
			}
		}
		
		private static const OPENING_DELAY:Number = 200;
		private var openingTimer:Timer;
		private function startTimer():void
		{
			destroyTimer();
			
			openingTimer = new Timer(OPENING_DELAY, 1);
			openingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onOpeningTimerComplete);
			openingTimer.start();
		}
		
		private function destroyTimer():void
		{
			if (openingTimer != null)
			{
				openingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onOpeningTimerComplete);
				openingTimer.stop();
				openingTimer = null;
			}
			
			if (closeTimer != null)
			{
				closeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCloseTimerComplete);
				closeTimer.stop();
				closeTimer = null;
			}
		}
		
		private function onOpeningTimerComplete(evt:TimerEvent):void
		{
			destroyTimer();
			
			if (extendArea)
			{
				show();
			}
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			on_mouse_out = true;
			//启动延时
			
			startCloseTimer();
		}
		
		private static const CLOSE_DELAY:Number = 100;
		private var closeTimer:Timer;
		private function startCloseTimer():void
		{
			destroyTimer();
			
			closeTimer = new Timer(CLOSE_DELAY, 1);
			closeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCloseTimerComplete);
			closeTimer.start();
		}
		
		private function onCloseTimerComplete(evt:TimerEvent):void
		{
			destroyTimer();
			
			if (extendArea) checkMouseAway();
		}
		
		private function onMouseDown(evt:MouseEvent):void
		{
			if (mouseY < 10) return;
			destroyTimer();
			if (extendArea)
			{
				show();
			}
		}
		
		private function onMouseLeave(evt:Event):void
		{
			destroyTimer();
			
			if (extendArea&&extendArea.visible) {
				hidden();
			}
		}
		
		private function checkMouseAway():void
		{
			var point:Point = new Point(extendArea.mouseX, extendArea.mouseY);
			var mouse_away:Boolean = Check.Out(point, rectangle);
			if (mouse_away) hidden();
			else{
				Scheduler.setTimeout(250, hiddenTimeOut);
			}
		}
		
		private function hiddenTimeOut(evt:SchedulerEvent):void
		{
			checkMouseAway();
		}
		
		override protected function processEnabledChange():void
		{
			if (enabled)
			{
				btn.enabled = true;
				btn.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
				
				stepped.alpha = 1;
				
				if (extendArea) extendArea.addEventListener(MouseEvent.MOUSE_DOWN, onExtendAreaMouseDown);
				if (extendArea) addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				if (extendArea) addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				if (stage) stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			}
			else {
				btn.enabled = false;
				btn.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
				btn.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stepped.alpha = .3;
				if (extendArea) extendArea.removeEventListener(MouseEvent.MOUSE_DOWN, onExtendAreaMouseDown);
				if (extendArea) removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				if (extendArea) removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				if (stage) stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
				if (extendArea) removeMouseEvent();
			}
		}
		
		/*
		 * 根据音量更新音量按钮图标
		 */
		private function updateStepped(v:Number):void
		{
			if (v < _min_volume) stepped.gotoAndStop(1);
			if (v >= _min_volume && v < 0.4) stepped.gotoAndStop(2);
			if (v >= 0.4 && v < 0.7) stepped.gotoAndStop(3);
			if (v >= 0.7) stepped.gotoAndStop(4);
		}
		
		/*
		 * 根据音量更新音量控制器
		 */
		private function updataTrack(v:Number):void
		{
			scrubTrack.scaleY = v;
		}
		
		/*
		 * 皮肤即时音量设置
		 */
		private function setVolume(v:Number):void
		{
			_volume = int(v*100)/100;
			if (_volume < _min_volume) _volume = 0;
			if (_volume > 1) _volume = 1;
			
			updateStepped(_volume);
			if(extendArea) updataTrack(_volume);
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		/*
		 * 皮肤音量设置消息入口
		 */
		public function set volume(n:Number):void
		{
			var v:Number;
			if (n < _min_volume)
			{
				mute = true;
				v = 0;
			}
			else {
				mute = false;
				v = n;
			}
			
			setVolume(v);
			
			_old_volume = _volume;
		}
		
		public function get mute():Boolean
		{
			return _mute;
		}
		
		public function set mute(b:Boolean):void
		{
			_mute = b;
		}
		
		private var _mute:Boolean;
		private var _volume:Number = 1.0;
		private var _default_volume:Number = 0.5;
		private var _old_volume:Number;
		private var _min_volume:Number = 0.05;
		private var btn:Button;
		private var stepped:MovieClip;
		
		private var extendArea:HasBgImgLayoutSprite;
		private var rectangle:Rectangle;
		private var tween:Tween;
		
		private var volumeControlMask:Sprite;
		private var scrubTrack:Sprite;
		
		private var trackTimer:Timer;
		private const UPDATE_INTERVAL:int = 40;
	}

}