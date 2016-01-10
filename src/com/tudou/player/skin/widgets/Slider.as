package com.tudou.player.skin.widgets
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import com.tudou.player.skin.events.ScrubberEvent;

	[Event(name = "scrubStart", type = "org.osmf.samples.controlbar.ScrubberEvent")]
	
	[Event(name = "scrubUpdate", type = "org.osmf.samples.controlbar.ScrubberEvent")]
	
	[Event(name="scrubEnd", type="org.osmf.samples.controlbar.ScrubberEvent")]
	
	/**
	 * Slider
	 */ 
	public class Slider extends Sprite
	{
		public function Slider(normal:DisplayObject, focused:DisplayObject = null, pressed:DisplayObject = null, disabled:DisplayObject = null)
		{
			this.normal = normal;
			this.focused = focused;
			this.pressed = pressed;
			this.disabled = disabled;
			this.mouseChildren = false;
			
			scrubTimer = new Timer(UPDATE_INTERVAL);
			scrubTimer.addEventListener(TimerEvent.TIMER, onDraggingTimer);
			
			updateFace(this.normal);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			super();
		}
		
		public function get sliding():Boolean
		{
			return _sliding;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = value;
			buttonMode = value;
			updateFace(_enabled ? normal : disabled);
			
		}
		
		/*
		 * 可拖动的源点
		 */
		public function set origin(value:Number):void
		{
			_origin = value;
		}
		
		public function get origin():Number
		{
			return _origin;
		}
		
		/*
		 * 可拖动的X轴范围
		 */
		public function set rangeX(value:Number):void
		{
			_rangeX = value;
		}
		public function get rangeX():Number
		{
			return _rangeX;
		}
		
		/*
		 * 可拖动的Y轴范围
		 */
		public function set rangeY(value:Number):void
		{
			_rangeY = value;
		}
		
		public function get rangeY():Number
		{
			return _rangeY;
		}
		
		private var rectangle:Rectangle;
		private var mouseStart:Point;
		private var spriteStart:Point;
		public function start(lockCenter:Boolean = true):void
		{
			if (_enabled && _sliding == false)
			{
				_sliding = true;
				stage.addEventListener(MouseEvent.MOUSE_UP, onStageExitDrag);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageDrag);
				updateFace(pressed);
				scrubTimer.start();
				dispatchEvent(new ScrubberEvent(ScrubberEvent.SCRUB_START));
				
				var stagePoint:Point = this.localToGlobal(new Point(this.mouseX, this.mouseY));
				mouseStart = new Point(stagePoint.x, stagePoint.y);
				spriteStart = new Point(this.x, this.y);
				rectangle =new Rectangle
							( rangeY == 0.0 ? _origin : x
							, rangeX == 0.0 ? _origin : y
							, _rangeX
							, _rangeY
							);
			}
		}
		
		private function onStageDrag(evt:MouseEvent):void
		{
			if (!rectangle) return;
			var _mi:Number;
			var _mx:Number;
			if (rectangle.width > 0)
			{
				var _x:Number = spriteStart.x + evt.stageX - mouseStart.x;
				_mi = rectangle.x;
				_mx = rectangle.x + rectangle.width;
				if (_x >= _mi && _x <= _mx)
				{
					this.x = _x;
				}
				else if (_x < _mi) {
					this.x = _mi;
				}
				else if (_x > _mx) {
					this.x = _mx;
				}
			}
			if (rectangle.height > 0)
			{
				var _y:Number = spriteStart.y + evt.stageY - mouseStart.y;
				_mi = rectangle.y;
				_mx = rectangle.y + rectangle.height;
				if (_y >= _mi && _y <= _mx)
				{
					this.y = _y;
				}
				else if (_y < _mi) {
					this.y = _mi;
				}
				else if (_y > _mx) {
					this.y = _mx;
				}
			}
		}
		
		public function stop():void
		{
			if (_enabled && _sliding)
			{
				scrubTimer.stop();
				updateFace(normal);
				_sliding = false;
				
				mouseStart = null;
				spriteStart = null;
				rectangle = null;
				try
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP, onStageExitDrag);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageDrag);
				}
				catch (e:Error){
					// swallow this
				}
				dispatchEvent(new ScrubberEvent(ScrubberEvent.SCRUB_END));
				
			}
		}
		
		// Internals
		//
		
		private function updateFace(face:DisplayObject):void
		{
			if (face == null) return;
			if (currentFace != face)
			{
				if (currentFace)
				{
					removeChild(currentFace);
				}
				
				currentFace = face;
				
				if (currentFace)
				{
					addChild(currentFace);
				}
			}
		}
		
		/*
		 * 检查asset，将其源点居中
		 */
		private function changeOrange(s:DisplayObject, _x:Number, _y:Number):void
		{
			var spr:Sprite = s as Sprite;
			if (spr)
			{
				var ln:int = spr.numChildren;
				for (var i:int = 0; i != ln; i++)
				{
					var m:DisplayObject = spr.getChildAt(i) as DisplayObject;
					if (m) {
						m.x -= _x;
						m.y -= _y;
					}
				}
				return;
			}
			
			var bmp:Bitmap = s as Bitmap;
			if (bmp)
			{
				bmp.bitmapData.scroll( -_x, -_y);
				return;
			}
		}
		
		public function onMouseDown(event:MouseEvent=null):void
		{
			start(false);
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			if(!_sliding) updateFace(this.focused);
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			if(!_sliding) updateFace(this.normal);
		}
		
		private function onStageExitDrag(event:MouseEvent):void
		{
			stop();
		}
		
		private function onDraggingTimer(event:TimerEvent):void
		{
			dispatchEvent(new ScrubberEvent(ScrubberEvent.SCRUB_UPDATE));
		}
		
		private const UPDATE_INTERVAL:int = 40
		private var currentFace:DisplayObject;
		protected var normal:DisplayObject;
		protected var focused:DisplayObject;
		protected var pressed:DisplayObject;
		protected var disabled:DisplayObject;
		
		private var _enabled:Boolean = true;
		private var _origin:Number = 0.0;
		private var _rangeX:Number = 100.0;
		private var _rangeY:Number = 100.0;
		
		private var _sliding:Boolean;
		private var scrubTimer:Timer;
	}
}