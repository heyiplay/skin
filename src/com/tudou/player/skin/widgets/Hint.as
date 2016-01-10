package com.tudou.player.skin.widgets
{
	import com.tudou.utils.Check;
	import com.tudou.utils.Global;
	import com.tudou.utils.Scheduler;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	/**
	 * 全局动态提示，使用注册的方式为显示对象实现提示功能。
	 * 
	 * @author 8088
	 */
	public class Hint extends Sprite
	{
		public function Hint(lock:Class = null)
		{
			if (lock != ConstructorLock)
			{
				throw new IllegalOperationError("Hint 是单例模式，禁止外部实例化！!");
			}
			
			mouseChildren = false;
			mouseEnabled = false;
			
			//..
			_area = new Sprite();
			addChild(_area);
			
			var format:TextFormat = new TextFormat();
			format.size = _size;
			format.align = TextFormatAlign.CENTER;
			format.font = "Arial";
			
			_label = new TextField();
			_label.x = 2;
			_label.y = 4;
			_label.height = 24;
			_label.width = 20;
			_label.multiline = false;
			_label.wordWrap = false;
			_label.defaultTextFormat = format;
			_label.textColor = defaultColor;
			_label.text = defaultText;
			_label.mouseEnabled = false;
			_area.addChild(_label);
			
			drawBg(0, 0);
			
		}
		
		/**
		 * 为显示对象注册提示，Hint 是单例模式，只能通过此接口注册使用。
		 * 
		 * @param view:InteractiveObject 需要注册提示的显示对象。
		 * @param alt:String 显示对象的提示信息。
		 */
		public static function register(view:InteractiveObject, alt:String = ""):void {
			if (view.stage == null)
			{
				throw new ArgumentError("Stage 不能为 null！！");
			}
			
			if (instance == null)
			{
				instance = new Hint(ConstructorLock);
				instance._stage = view.stage;
				
				instance._stage.addEventListener(Event.MOUSE_LEAVE, instance.onMouseLeaveHandler);
			}
			
			if (view.accessibilityProperties == null)
			{
				var ap:AccessibilityProperties = new AccessibilityProperties();
				ap.description = alt;
				view.accessibilityProperties = ap;
			}
			else {
				view.accessibilityProperties.description = alt;
			}
			
			view.addEventListener(MouseEvent.ROLL_OVER, instance.onMouseHandler);
			
		}
		
		/**
		 * 取消显示对象的提示功能。
		 * 
		 * @param view:InteractiveObject 需要注册提示的显示对象。
		 */
		public static function unregister(view:InteractiveObject):void {
			if (instance != null) {
				view.accessibilityProperties = null;
				view.removeEventListener(MouseEvent.ROLL_OVER, instance.onMouseHandler);
			}
		}
		
		/**
		 * 即时改变提示信息。
		 * 
		 * @param t:String 即时提示信息。
		 */
		public static function set text(t:String):void
		{
			if (t==null || t.length == 0)
			{
				instance.visible = false;
				return;
			}
			
			instance._text = t;
			instance._label.text = instance._text;
			instance._label.width = instance._label.textWidth + instance._size;
			
			instance.drawBg(instance._stage.mouseX, instance._stage.mouseY);
			instance.move(instance._stage.mouseX, instance._stage.mouseY);
			if(!instance.visible) instance.visible = true;
		}
		
		public static function get text():String
		{
			return instance._text;
		}
		
		public static function get label():TextField
		{
			return instance._label;
		}
        
        public static function get area():Sprite
        {
            return instance._area;
        }

		/**
		 * 即时改变提示信息,并插入显示其他信息
		 * 
		 * @param obj:DisplayObject 即时提示的其他信息，如文字、图片、视频等
		 * @param option:Object 插入设置(用于扩展其他功能)
		 */
		public static function insert(obj:DisplayObject, option:Object=null):void
		{
			if (obj==null)
			{
				instance.visible = false;
				throw new ArgumentError("插入Hint的显示对象不能为 null！！");
			}
			else {
				instance._area.addChild(obj);
				
				if (option)
				{
					if (option.labelX!=undefined) instance._label.x = option.labelX;
					if (option.labelY!=undefined) instance._label.y = option.labelY;
					if (option.areaWidth!=undefined) instance._area_w = option.areaWidth;
					if (option.areaHeight!=undefined) instance._area_h = option.areaHeight;
					//..
				}
				
				//重绘背景
				instance.drawBg(instance._stage.mouseX, instance._stage.mouseY);
				instance.move(instance._stage.mouseX, instance._stage.mouseY);
				if (!instance.visible) instance.visible = true;
			}
		}
		
        /**
         * 删除插入的可视信息
         * 
         * @param obj:DisplayObject 已经插入的可视信息。
         */
        public static function remove(obj:DisplayObject, option:Object=null):void
        {
            if (instance.mouse_on_hint) return;
            if (obj && instance._area.contains(obj))
            {
                if (option)
                {
                    if (option.labelX != undefined) instance._label.x = option.labelX;
                    if (option.labelY != undefined) instance._label.y = option.labelY;
                    if (option.areaWidth != undefined) instance._area_w = option.areaWidth;
                    if (option.areaHeight != undefined) instance._area_h = option.areaHeight;
                    //..
                }
                
                instance._area.removeChild(obj);
                instance.drawBg(instance._stage.mouseX, instance._stage.mouseY);
                instance.move(instance._stage.mouseX, instance._stage.mouseY);
            }
        }
		
		private var _t_w:Number = 9; //箭头宽度
		private var _t_h:Number = 5; //箭头高度
		private function drawBg(mouse_x:Number, mouse_y:Number):void
		{
			var _x:int = int(_area.x);
			var _y:int = int(_area.y);
			var _w:int = _area_w?_area_w:int(_area.width);
			var _h:int = _area_h?_area_h:int(_area.height);
			
			graphics.clear();
			
			graphics.beginFill(0x222222, 1);
			graphics.drawRect(_x, _y, _w + 4, _h + 4);
			
			graphics.beginFill(0x222222, 1);
			graphics.drawRect(_x + 1, _y + 1, _w + 2, _h + 2);
			
			graphics.beginFill(0x222222, 1);
			graphics.drawRect(_x + 2, _y + 2, _w, _h);
			graphics.endFill();
			
			if (!_stage) return;
			
			var vector:Vector.<Number>;
			var p1:Point = new Point();
			var p2:Point = new Point();
			var p3:Point = new Point();
			var _v:int;
			var _t:int;
			
			if (mouse_x > this.width*.5 && mouse_x < (_stage.stageWidth - this.width*.5))
			{
				p1.x = (_w + 4+1) * .5;
				p2.x = p1.x - _t_w * .5;
				p3.x = p1.x + _t_w * .5;
			}
			else {
				if (mouse_x < _stage.stageWidth*.5)
				{
					p1.x = Math.max(2, _area.mouseX);
					p2.x = Math.max(2, p1.x - _t_w * .5);
					p3.x = p1.x + _t_w * .5;
				}
				else {
					p1.x = Math.min(_w+2, _area.mouseX);;
					p2.x = p1.x - _t_w * .5;
					p3.x = Math.min(_w+2, p1.x + _t_w * .5);
				};
			}
			if (!isNaN(fix_v) && !isNaN(fix_t))
			{
				_v = fix_v;
				_t = fix_t;
			}
			else {
				if (mouse_y < (_stage.stageHeight * .5))//箭头在上
				{
					_v = 0;
					_t = -1;
				}
				else {//箭头在下
					_v = 1;
					_t = 1;
				}
			}
			
			p1.y = _h * _v + _t_h * _t + 2;
			p2.y = p1.y + _t_h * (-_t);
			p3.y = p1.y + _t_h * (-_t);
			
			vector = new Vector.<Number>();
			vector.push(p1.x, p1.y + _t);
			vector.push(p2.x-1, p2.y + _t);
			vector.push(p3.x+1, p3.y + _t);
			
			graphics.beginFill(0x222222, 1);
			graphics.drawTriangles(vector);
			
			vector= new Vector.<Number>();
			vector.push(p1.x, p1.y);
			vector.push(p2.x, p2.y);
			vector.push(p3.x, p3.y);
			
			graphics.beginFill(0x222222, 1);
			graphics.drawTriangles(vector);
			
			graphics.endFill();
			
		}
		
		private function onMouseLeaveHandler(evt:Event=null):void
		{
			var ln:int = _area.numChildren;
			
			if (ln > 1)
			{
				while (_area.numChildren > 1)
				{
					_area.removeChildAt(instance._area.numChildren - 1);
				}
				drawBg(instance._stage.mouseX, instance._stage.mouseY);
				move(instance._stage.mouseX, instance._stage.mouseY);
			}
		}
		
		private function onMouseHandler(evt:MouseEvent):void
		{
			switch(evt.type) {
				case MouseEvent.ROLL_OUT:
					//mark:如果不做延时，可交互的提示会有问题，如果做延时底部按钮正常的提示有时不出来。因此在显示对象上增加提示可交互配置来处理。
					if(fix_interactive)Scheduler.setTimeout(20, clear);
					else clear();
					break;
				case MouseEvent.MOUSE_MOVE:
					move(evt.stageX, evt.stageY);
					break;
				case MouseEvent.ROLL_OVER:
					init(evt.target as InteractiveObject);
					break;
			}
		}
		
		private function hintRollOverHandler(evt:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, hintRollOverHandler);
			mouse_on_hint = true;
			this.addEventListener(MouseEvent.ROLL_OUT, hintRollOutHandler);
			
		}
		
		private function hintRollOutHandler(evt:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.ROLL_OUT, hintRollOutHandler);
			mouse_on_hint = false;
			clear();
		}
		
		private function init(view:InteractiveObject):void
		{
			_view = view;
			_view.addEventListener(MouseEvent.ROLL_OUT, onMouseHandler);
			_view.addEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
			
			//特殊设置
			if (_view.hasOwnProperty("hintColor"))
			{
				_color = _view["hintColor"];
				if(_color) _label.textColor = _color;
			}
			
			var view_point:Point = _view.localToGlobal(new Point(0, 0));
			if (_view.hasOwnProperty("hintX"))
			{
				fix_x = view_point.x + _view["hintX"];
			}
			if (_view.hasOwnProperty("hintY"))
			{
				fix_y = view_point.y + _view["hintY"];
			}
			
			if (_view.hasOwnProperty("hintV"))
			{
				fix_v = _view["hintV"];
			}
			if (_view.hasOwnProperty("hintT"))
			{
				fix_t = _view["hintT"];
			}
			
			if (_view.hasOwnProperty("hintInteractive"))
			{
				fix_interactive = _view["hintInteractive"];
			}
			else {
				fix_interactive = false;
			}
			
			if (_view.hasOwnProperty("hintHover"))
			{
				_hover = _view["hintHover"];
				if (_hover)
				{
					mouseChildren = true;
					mouseEnabled = true;
					this.addEventListener(MouseEvent.ROLL_OVER, hintRollOverHandler);
				}
			}
			
			//提示信息
			if (_view.accessibilityProperties)
			{
				_text = _view.accessibilityProperties.description;
				var max_w:Number;
				if (_stage&&_text) {
					max_w = _stage.stageWidth;
					_text = Check.View(_text, max_w);
				}
				text = _text;
			}
			
			//启动延时
			if (openingTimer && openingTimer.running)
			{
				openingTimer.reset();
				openingTimer.start();	
			}
			else {
				startTimer();
			}
		}
		
		private function clear(evt:Event = null):void
		{
			if (_stage && !mouse_on_hint)
			{
				mouseChildren = false;
				mouseEnabled = false;
				
				destroyTimer();
				
				var ln:int = _area.numChildren;
				if (ln > 1)
				{
					while (_area.numChildren > 1)
					{
						_area.removeChildAt(_area.numChildren - 1);
					}
				}
				
				if (_stage.contains(this)) _stage.removeChild(this);
				
				if (_view)
				{
					_view.removeEventListener(MouseEvent.ROLL_OUT, onMouseHandler);
					_view.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
					_view = null;
				}
				
				fix_x = Number.NaN;
				fix_y = Number.NaN;
				fix_v = Number.NaN;
				fix_t = Number.NaN;
				
				_text = defaultText;
				_color = defaultColor;
				_hover = false;
				mouse_on_hint = false;
				
				_label.x = 2;
				_label.y = 4;
				_label.textColor = _color;
				_label.text = _text;
				_label.width = _label.textWidth + _size;
				
				_area_w = 0;
				_area_h = 0;
			}
			
		}
		
		private function move(_x:Number, _y:Number):void {
			var m_x:Number;
			var m_y:Number;
			
			if (!isNaN(fix_x)) m_x = fix_x;
			else m_x = _x;
			
			if (m_x > this.width*.5 && m_x < (_stage.stageWidth - this.width*.5))
			{
				this.x = int(m_x - this.width*.5);
			}
			else {
				if (m_x < this.width) this.x = 0;
				else this.x = int(_stage.stageWidth - this.width);
			}
			
			if (!isNaN(fix_y)) m_y = fix_y;
			else m_y = _y;
			
			if (m_y < (_stage.stageHeight * .5))
			{
				this.y = int(m_y + this.height);
			}
			else {
				this.y = int(m_y - this.height);
			}
			drawBg(m_x, m_y);
		}
		
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
		}
		
		private function onOpeningTimerComplete(evt:TimerEvent):void
		{
			openingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onOpeningTimerComplete);
			openingTimer.stop();
			openingTimer = null;
			
			if (_text==null || _text.length == 0) this.visible = false;
			else this.visible = true;
			_stage.addChild(this);
		}
		
		public static var instance:Hint;
		private static const OPENING_DELAY:Number = 250;
		
		private var _stage:Stage;
		private var _view:InteractiveObject;
		private var _text:String = "";
		private var _color:uint;
		private var _label:TextField;
		private var _area:Sprite;
		private var _size:Number = 12;
		private var _hover:Boolean = false;
		
		private var mouse_on_hint:Boolean = false;
		
		private var fix_x:Number;
		private var fix_y:Number;
		
		private var fix_v:Number;
		private var fix_t:Number;
		
		private var fix_interactive:Boolean;
		
		private var _area_w:Number=0;
		private var _area_h:Number=0;
		
		private var openingTimer:Timer;
		private var defaultText:String = "";
		private var defaultColor:uint = 0xFFFFFF;
	}

}

class ConstructorLock {};