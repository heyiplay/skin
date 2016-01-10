package com.tudou.player.skin.widgets 
{
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.events.ScrubberEvent;
	import com.tudou.layout.LayoutSprite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.system.ApplicationDomain;
	
	/**
	 * 滑动条
	 * 
	 * @author 8088
	 */
	public class SliderBar extends LayoutSprite
	{
		
		public function SliderBar(tracker:DisplayObject, slider_normal:DisplayObject, slider_focused:DisplayObject = null, slider_pressed:DisplayObject = null, slider_disabled:DisplayObject = null)
		{
			super();
			
			this.tracker = tracker;
			
			slider = new Slider(slider_normal, slider_focused, slider_pressed, slider_disabled);
			
		}
		
		override protected function getDefinitionByName(url:String):Object
		{
			return ApplicationDomain.currentDomain.getDefinition(url);
		}
		
		private function sliderStartHandler(evt:ScrubberEvent=null):void
		{
			_sliding = true;
			if(evt) dispatchEvent(evt);
		}
		
		private function sliderUpdateHandler(evt:ScrubberEvent = null):void
		{
			var _n:Number = slider.x / slider.rangeX;
			slideToX(_n);
			dispatch(MouseEvent.MOUSE_MOVE);
		}
		
		private function sliderEndHandler(evt:ScrubberEvent = null):void
		{
			_sliding = false;
			if (evt) dispatchEvent(evt);
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:id, level:NetStatusEventLevel.STATUS, data:sliderRate, action:MouseEvent.MOUSE_UP}
				)
			);
		}
		
		private function sliderBarDownHandler(evt:MouseEvent):void
		{
			if (evt.target == slider) return;
			
			var n:Number = mouseX / sliderEnd;
			slideToX(n);
			dispatch(evt.type);
			
			if (!_sliding)
			{
				slider.onMouseDown();
				sliderStartHandler();
			}
		}
		
		private function mouseLeaveHandler(evt:Event):void
		{
			if (slider) slider.stop();
		}
		
		private function dispatch(_action:String):void
		{
			if (sliderRate == _old_rate) return;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:id, level:NetStatusEventLevel.STATUS, data:sliderRate, action:_action}
				)
			);
			
			_old_rate = sliderRate;
		}
		
		
		//
		private function slideToX(n:Number):void
		{
			setTrackerWidth(n);
			if (!_sliding)
			{
				setSliderX();
			}
		}
		
		private function setTrackerWidth(num:Number):void
		{
			sliderRate = num;
			if(tracker) tracker.width = sliderEnd * num;
		}
		
		private function setSliderX():void
		{
			if (tracker && slider) slider.x = tracker.x + tracker.width;
		}
		
		override protected function onStage(evt:Event=null):void
		{
			super.onStage(null);
			
			addChild(tracker);
			
			slider.y = int(tracker.height * .5);
			slider.origin = 0.0;
			slider.rangeY = 0.0;
			slider.rangeX = sliderEnd;
			addChild(slider);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(evt:MouseEvent):void
		{
			if (tracker && slider)
			{
				if (slider.x != (tracker.x + tracker.width))
				{
					var n:Number = slider.x / sliderEnd;
					setTrackerWidth(n);
				}
			}
		}
		
		//如果是横向滑动条
		override protected function reSetWidth():void
		{
			sliderEnd = this.width;
			
			//自适应尺寸变化...
		}
		
		//API
		public function set slide(num:Number):void
		{
			if (num<0 || num>1) return;
			
			if (!_sliding)
			{
				setTrackerWidth(num);
				setSliderX();
			}
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			processEnabledChange();
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		protected function processEnabledChange():void 
		{
			slider.enabled = enabled;
			mouseEnabled = enabled;
			buttonMode = enabled;
			tracker.visible = enabled;
			if (enabled)
			{
				slider.addEventListener(ScrubberEvent.SCRUB_START, sliderStartHandler);
				slider.addEventListener(ScrubberEvent.SCRUB_UPDATE, sliderUpdateHandler);
				slider.addEventListener(ScrubberEvent.SCRUB_END, sliderEndHandler);
				this.addEventListener(MouseEvent.MOUSE_DOWN, sliderBarDownHandler);
				if (stage) stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			}
			else {
				slider.removeEventListener(ScrubberEvent.SCRUB_START, sliderStartHandler);
				slider.removeEventListener(ScrubberEvent.SCRUB_UPDATE, sliderUpdateHandler);
				slider.removeEventListener(ScrubberEvent.SCRUB_END, sliderEndHandler);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, sliderBarDownHandler);
				if (stage) stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			}
		}
		
		
		private var tracker:DisplayObject;
		private var scrub:Sprite;
		private var slider:Slider;
		private var _enabled:Boolean;
		private var _sliding:Boolean;
		public var sliderStart:Number = 0.0;
		public var sliderEnd:Number = 0.0;
		public var sliderRate:Number = 0.0;
		public var _old_rate:Number;
	}

}