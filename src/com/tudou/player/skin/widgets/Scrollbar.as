package com.tudou.player.skin.widgets 
{
	import com.tudou.utils.Scheduler;
	import com.tudou.utils.Debug;
	import com.tudou.events.SchedulerEvent;
	import com.tudou.player.skin.events.ScrollbarEvent;
	import com.tudou.player.skin.configuration.Keyword;
	import flash.events.Event;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	/**
	 * Scrollbar 
	 */
	public class Scrollbar extends Sprite
	{
		
		public function Scrollbar( background:DisplayObject
								, thumb:Button
								, up:Button = null
								, down:Button = null
								)
		{
			super();
			
			this.background = background;
			this.up = up;
			this.thumb = thumb;
			this.down = down;
			
			init();
		}
		
		private function init(evt:Event = null):void
		{
			tabChildren = false;
			
			if (up)
			{
				addChild(up);
				background.y = up.y + up.height;
			}
			
			addChild(background);
			
			thumb_y = background.y;
			thumb.y = background.y;
			_min = 30;
			_b = 0;
			addChild(thumb);
			
			if (down)
			{
				down.y = background.y + background.height;
				addChild(down);
			}
			
			
			recalculate();
		}
		
		override public function set height(_h:Number):void {
			
			if (up && down) background.height = _h - up.height - down.height;
			else background.height = _h;
			
			if(down) down.y = background.y + background.height;
			
			if (_value >= 1) recalculate();
			
			super.height = this.height;
		}
		
		private var _min:Number;
		//recalculateThumb
		private function recalculateThumb():void {
			var thumb_n:Number = background.height * (this.height/view.height);
			if (thumb_n < _min) thumb.height = _min;
			else {
				thumb.height = thumb_n;
				if (thumb.height + thumb.y > background.height + background.y) thumb.y = background.height + background.y - thumb.height;
				
			}
			
			if (!thumb.visible) {
				if (thumb_n<background.height){
					thumb.visible = true;
				}else {
					thumb.height = _min;
					thumb.visible = false;
				}
			}
			
		}
		
		private var dragRect:Rectangle;
		private var _b:Number = 0;
		private function recalculate():void {
			var r_w:Number;
			var r_h:Number;
			
			r_w =  background.x;
			r_h = Math.round(background.height - thumb.height);
			
			_b = _value / r_h;
			
			if (_b > 0) scrollView(scroll_view);
			
			dragRect = new Rectangle(background.x, background.y, r_w, r_h);
		}
		
		private function thumbDownHandler(evt:MouseEvent):void {
			thumb.startDrag(false, dragRect);
			thumbOldY = thumb.y;
			thumbDragStart = true;
			dragEventStart = false;
			thumb.addEventListener(Event.ENTER_FRAME, dispatchChange);		
			if (_m_c) _view["mouseChildren"] = false;
			if (_m_e) _view["mouseEnabled"] = false;
		}
		
		private function barUpHandler(evt:Event):void {
			thumb.removeEventListener(Event.ENTER_FRAME, dispatchChange);
			thumb.stopDrag();
			Scheduler.setTimeout(200, restore);
			
			if (dragEventStart && thumbDragStart)
			{
				dragEventStart = false;
				thumbDragStart = false;
				thumbOldY = 0;
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.SCOLLBAR_DRAG_END, (thumb.y - background.y) / (background.height - thumb.height)));
			}
		}
		
		private function restore(evt:SchedulerEvent):void
		{
			if (_m_c) _view["mouseChildren"] = _m_c;
			if (_m_e) _view["mouseEnabled"] = _m_e;
		}
		
		private function dispatchChange(evt:Event = null):void {
			var _num:int;
			_num = int((thumb.y - background.y) * _b);
			_view.y = -_num;
						
			var dRange:Number = background.height * 0.01 > 1 ? 1 : background.height * 0.01;
			if (thumbDragStart && !dragEventStart && Math.abs(thumb.y - thumbOldY) > dRange)
			{
				dragEventStart = true;
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.SCOLLBAR_DRAG_START, (thumbOldY - background.y) / (background.height - thumb.height)));
			}
		}
				
		private var thumb_y:Number= 0;
		private var scroll_view:Number= 0;
		public function scrollView(num:Number):void
		{
			if (_b == 0)
			{
				scroll_view = num;
				return;
			}
			thumb_y = (num / _b) + background.y;
			
			if ((thumb_y+thumb.height) > background.y + background.height)
			{
				thumb_y = background.y + background.height - thumb.height;
			}
			
			thumb.y = thumb_y;
			dispatchChange();
		}
		
		private function bgDownHandler(evt:MouseEvent):void {
			if (this.mouseY > thumb.y)
			{
				if ((background.height - thumb.y - thumb.height) > thumb.height)
				{
					thumb.y +=thumb.height;
				}
				else{
					thumb.y = background.y + dragRect.height;
				}
			}else {
				var upHei:Number = (up == null ? 0 : up.height);
				if ((thumb.y - upHei) > thumb.height)
				{
					thumb.y -= thumb.height;
				}
				else{
					thumb.y = background.y;
				}
			}
			dispatchChange();
		}
		
		private function mouseWheel(evt:MouseEvent):void {
			thumb.y -= int(evt.delta);
			if (thumb.y <= background.y)
			{
				thumb.y = background.y;
			}
			else if (thumb.y >= (background.y + dragRect.height)){
				thumb.y = background.y + dragRect.height;
			}
			dispatchChange();
		}
		
		//API
		private var _view:DisplayObject;
		private var _value:Number;
		private var _m_c:Boolean;
		private var _m_e:Boolean;
		public function scroll(view:DisplayObject, value:Number):void
		{
			_view = view;
			_value = value;
			if (_view.hasOwnProperty("mouseChildren")) _m_c = _view["mouseChildren"];
			if (_view.hasOwnProperty("mouseEnabled")) _m_e = _view["mouseEnabled"];
			if (_value <= 0) {
				enabled = false;
				_b = 0;
				thumb_y = background.y;
				thumb.y = background.y;
				thumb.height = background.height;
				_view.y = 0;
				return;
			}else {
				enabled = true;
				recalculateThumb();
				recalculate();
			}
			dispatchChange();
		}
		
		public function onMouse(on:Boolean):void
		{
			if (on)
			{
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
			else {
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
		}
		
		public function get view():DisplayObject
		{
			return _view;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(name:String):void
		{
			_id = name;
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
			visible = enabled;
			mouseEnabled = enabled;
			buttonMode = enabled;
			
			if(up) up.enabled = enabled;
			thumb.enabled = enabled;
			if(down) down.enabled = enabled;
			
			if (enabled)
			{
				thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDownHandler);
				thumb.addEventListener(MouseEvent.MOUSE_UP, barUpHandler);
				background.addEventListener(MouseEvent.MOUSE_DOWN, bgDownHandler);
				if (stage)
				{
					stage.addEventListener(MouseEvent.MOUSE_UP, barUpHandler);
					stage.addEventListener(Event.MOUSE_LEAVE, barUpHandler);
				}
			}
			else {
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDownHandler);
				thumb.removeEventListener(MouseEvent.MOUSE_UP, barUpHandler);
				background.removeEventListener(MouseEvent.MOUSE_DOWN, bgDownHandler);
				if (stage)
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP, barUpHandler);
					stage.removeEventListener(Event.MOUSE_LEAVE, barUpHandler);
					stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
				}
			}
		}
		
		
		protected var background:DisplayObject;
		protected var up:Button;
		protected var thumb:Button;
		protected var down:Button;
		private var _id:String;
		
		private var thumbDragStart:Boolean; //滑块准备好了被拖拽
		private var dragEventStart:Boolean; //拖拽滑块事件开始
		private var thumbOldY:Number;
		
		private var _enabled:Boolean;
		
		
	}

}