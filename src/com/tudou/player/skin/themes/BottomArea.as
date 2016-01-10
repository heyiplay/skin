package com.tudou.player.skin.themes 
{
	import __AS3__.vec.Vector;
	import com.tudou.events.SchedulerEvent;
	import com.tudou.events.TweenEvent;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.configuration.SizeMode;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.utils.Check;
	import com.tudou.utils.Scheduler;
	import com.tudou.utils.Tween;
	import com.tudou.utils.Tween;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * 底部控制区域
	 */
	public class BottomArea extends ControlArea
	{
		
		public function BottomArea(widgets:Vector.<String>)
		{
			super(widgets);
			
			_id = "BottomArea";
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			skin_theme = parent["info"].theme;
			
			if (skin_theme == "TDTV" || skin_theme == "TDWS" || skin_theme == "YKWS")
			{
				showTween = new Tween(this);
			}
		}
		
		override protected function setMouseHoverRectangle():void
		{
			
			if (this.parent)
			{
				r_x = 0
				r_y = Math.min(-this.parent.height * .3, -120);
				r_w = this.width;
				r_h = this.height;
			}
			
			rectangle = new Rectangle(r_x, r_y, r_w, r_h);
		}
		
		override protected function mouseMove(evt:Event):void
		{
			super.mouseMove(null);
			
			if (this.autoHide&&(skin_theme == "TDTV" || skin_theme == "TDWS" || skin_theme == "YKWS"))
			{
				showTween.to( { alpha:1 }, 400);
				resetShowTimer();
			}
		}
		
		protected function resetShowTimer():void
		{
			if (autoShowTimer!=null)
			{
				autoShowTimer.reset();
				autoShowTimer.start();
			}
			else {
				autoShowTimer = new Timer(autoHideTimeout, 1);
				autoShowTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoShowTimerHandler);
				autoShowTimer.start();
			}
		}
		
		private function destroyShowTimer():void
		{
			if (autoShowTimer) {
				autoShowTimer.stop();
				autoShowTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, autoShowTimerHandler);
				autoShowTimer = null;
			}
		}
		
		private function autoShowTimerHandler(evt:TimerEvent):void
		{
			var point:Point = new Point(this.mouseX, this.mouseY);
			var mouse_away:Boolean = Check.Out(point, rectangle);
			
			if (mouse_away)
			{
				if ((_global.status.displayState != StageDisplayState.NORMAL)&&this.autoHide&&(skin_theme == "TDTV" || skin_theme == "TDWS" || skin_theme == "YKWS"))
				{
					var _time:Number = 400;
					var _target:Object = { alpha:0 };
					
					if (alpha > 0) showTween.to(_target, _time);
					
					dispatchEvent( new NetStatusEvent
						( NetStatusEvent.NET_STATUS
						, false
						, false
						, 	{ code:SkinNetStatusEventCode.CONTROL_AREA_TWEEN_END
							, level:NetStatusEventLevel.STATUS
							, data:{ id:this.id }
							}
						)
					);
				}
			}
		}
		
		override public function onSizeModeChange(mode:String):void
		{
			super.onSizeModeChange(mode);
			
			if (!this.autoHide)
			{
				destroyShowTimer();
				if(showTween) showTween.cancel();
			}
		}
		
		private var skin_theme:String;
		private var showTween:Tween;
		private var autoShowTimer:Timer;
	}

}

