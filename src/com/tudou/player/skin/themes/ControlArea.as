package com.tudou.player.skin.themes 
{
	import __AS3__.vec.Vector;
	import com.tudou.events.SchedulerEvent;
	import com.tudou.events.TweenEvent;
	import com.tudou.layout.CSSDecoder;
	import com.tudou.layout.CSSKeyword;
	import com.tudou.player.skin.configuration.SizeMode;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.layout.LayoutSprite;
	import com.tudou.utils.Check;
	import com.tudou.utils.Debug;
	import com.tudou.utils.Scheduler;
	import com.tudou.utils.Tween;
	import com.tudou.utils.Utils;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.ui.Mouse;
	
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.skin.interfaces.IControlArea;
	import com.tudou.player.skin.interfaces.IWidget;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.widgets.WidgetsManager;
	import com.tudou.utils.HashMap;
	
	/**
	 * ControlArea
	 */
	public class ControlArea extends LayoutSprite implements IControlArea
	{
		
		public function ControlArea(classes:Vector.<String>) 
		{
			super();
			
			_assetsManager = ElementsProvider.getInstance().assetsManager;
			_widgetManager = ElementsProvider.getInstance().widgetsManager;
			
			widgetClass = classes;
			
			widgets = new HashMap();
			
			tween = new Tween(this);
			tween.addEventListener(TweenEvent.END, onTweenEnd);
		}
		
		public function configure(xml:XML, assetManager:AssetsManager):void
		{
			_configuration = xml;
		}
		
		public function get configuration():XML
		{
			return _configuration;
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			//
			build();
			
			setMouseHoverRectangle();
			
			hide_style = recount(hide_style_obj);
			show_style = recount(show_style_obj);
			
			//避免异步设置失败
			Scheduler.setTimeout(1, function(e:SchedulerEvent):void
			{
				autoHide = _autoHide;
			});
		}
		
		public function onSizeModeChange(mode:String):void
		{
			this.tween.finish();
			
			size_mode = mode;
			
			if (size_mode == SizeMode.FULL_SCREEN || size_mode == SizeMode.FULL_SCREEN_INTERACTIVE)
			{
				//mark:解决第一次全屏执行过程中，显示鼠标点未移出的bug。
				var _this:Sprite = this;
				Scheduler.setTimeout(100, function(evt:SchedulerEvent):void {
					var point:Point = new Point(_this.mouseX, _this.mouseY);
					var mouse_away:Boolean = Check.Out(point, rectangle);
					if(!mouse_away) mouseMove(null);
				});
			}
		}
		
		protected function setMouseHoverRectangle():void
		{
			r_x = 0;
			r_y = 0;
			r_w = this.width;
			r_h = this.height;
			rectangle = new Rectangle(r_x, r_y, r_w, r_h);
		}
		
		public function build():void
		{
			var ln:int = widgetClass.length;
			
			for (var i:int = 0; i != ln; i++)
			{
				var widget:Widget = _widgetManager.getWidget(widgetClass[i]);
				if (widget)
				{	
					widget.addEventListener(NetStatusEvent.NET_STATUS, onWidgetStatus);
					addChild(widget);
					widgets.put(widgetClass[i], widget);
				}
			}
		}
		
		public function addWidget(widget:Widget):void
		{
			addChild(widget);
			widgets.put(widget.id, widget);
		}
		
		protected function onWidgetStatus(evt:NetStatusEvent):void
		{
			dispatchEvent(evt);
		}
		
		protected function mouseLeve(evt:Event):void
		{
			tweenToHide(400);
		}
		
		private var tween_to_show:Boolean;
		protected function mouseMove(evt:Event):void
		{
			if (_global.status.screenChanging)
			{
				tween_to_show = false;
				return;
			}
			Mouse.show();
			
			var point:Point = new Point(this.mouseX, this.mouseY);
			var mouse_away:Boolean = Check.Out(point, rectangle);
			
			if (mouse_away)
			{
				resetTimer();
			}
			else {
				if (!tween_to_show)
				{
					tweenToShow(500);
					tween_to_show = true;
				}
			}
		}
		
		protected function resetTimer():void
		{
			if (autoHideTimer)
			{
				autoHideTimer.reset();
				autoHideTimer.start();
			}
			else {
				autoHideTimer = new Timer(autoHideTimeout, 1);
				autoHideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoHideTimerHandler);
				autoHideTimer.start();
			}
		}
		
		private function destroyTimer():void
		{
			if (autoHideTimer) {
				autoHideTimer.stop();
				autoHideTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, autoHideTimerHandler);
				autoHideTimer = null;
			}
		}
		
		protected function autoHideTimerHandler(evt:TimerEvent):void
		{
			var point:Point = new Point(this.mouseX, this.mouseY);
			var mouse_away:Boolean = Check.Out(point, rectangle);
			
			if (mouse_away)
			{
				tweenToHide(400);
			}
			else {
				tweenToShow(500);
			}
		}
		
		private var _dispatch:Boolean;
		public function tweenToHide(time:uint):void
		{
			if (this.visible == false) return;
			tween_to_show = false;
			
			tween.easeIn().to(hide_style, time);
			
			if (!_dispatch)
			{
				_dispatch = true;
				dispatchEvent( new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, 	{ code:SkinNetStatusEventCode.CONTROL_AREA_TWEEN_TO_HIDE
						, level:"status"
						, data:{ id:this.id, tween:{ time:time, effect:"easeIn", target:hide_style} }
						}
					)
				);
			}
		}
		
		public function tweenToShow(time:uint):void
		{
			if (this.visible == false) return;
			
			tween.easeOut().to( show_style, time);
			
			if (!_dispatch)
			{
				_dispatch = true;
				dispatchEvent( new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, 	{ code:SkinNetStatusEventCode.CONTROL_AREA_TWEEN_TO_SHOW
						, level:"status"
						, data:{ id:this.id, tween:{ time:time, effect:"easeIn", target:show_style} }
						}
					)
				);
			}
		}
		
		public function onTweenEnd(evt:TweenEvent):void
		{
			destroyTimer();
			
			if (this.alpha<0.01)_hide = true;
			else _hide = false;
			
			if (_dispatch)
			{
				_dispatch = false;
				dispatchEvent( new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, 	{ code:SkinNetStatusEventCode.CONTROL_AREA_TWEEN_END
						, level:"status"
						, data:{ id:this.id }
						}
					)
				);
			}
		}
		
		override public function setSize():void
		{
			super.setSize();
			
			hide_style = recount(hide_style_obj);
			show_style = recount(show_style_obj);
			
			setMouseHoverRectangle();
			
		}
		
		override protected function delayResize():void
		{
			autoHide = _autoHide;
		}
		
		public function get hide():Boolean
		{
			return _hide;
		}
		
		public function set hide(h:Boolean):void
		{
			if (this.visible == false) return;
			if (_hide == h) return;
			
			if (h)
			{
				tweenToHide(0);
			}
			else {
				tweenToShow(0);
			}
		}
		
		public function get autoHide():Boolean
		{
			return _autoHide;
		}
		
		public function set autoHide(value:Boolean):void
		{
			_autoHide = value;
			if (!stage) return;
			
			destroyTimer();
			
			if (_autoHide) {
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				stage.addEventListener(Event.MOUSE_LEAVE, mouseLeve);
				mouseMove(null);
			}
			else {
				Mouse.show();
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeve);
				if(_hide) tweenToShow(0);
			}
			
			//hide = _autoHide;
		}
		
		public function get autoHideTimeout():int
		{
			return _autoHideTimeout;
		}
		
		public function set autoHideTimeout(value:int):void
		{
			_autoHideTimeout = value;
		}
		
		public function get hideStyle():String
		{
			return _hide_style;
		}
		
		public function set hideStyle(style:String):void
		{
			_hide_style = style;
			
			var decoder:CSSDecoder = new CSSDecoder(_hide_style);
			hide_style_obj = decoder.getCSSObj();
			hide_style = recount(hide_style_obj);
		}
		
		private function recount(temp:Object):Object
		{
			if (!stage || !parent || !temp) return default_style;
			
			var target:Object = { };
			if (css.position == CSSKeyword.POSITION_STATIC)
			{
				if (temp.hasOwnProperty("x")) target.x = getPosition(CSSKeyword.WIDTH, temp.x);
				if (temp.hasOwnProperty("y")) target.y = getPosition(CSSKeyword.HEIGHT, temp.y);
			}
			else {
				if (temp.hasOwnProperty("left")) target.x = getPosition(CSSKeyword.WIDTH, temp.left);
				if (temp.hasOwnProperty("right")) target.x = getPosition(CSSKeyword.WIDTH, temp.right, 1);
				if (temp.hasOwnProperty("top")) target.y = getPosition(CSSKeyword.HEIGHT, temp.top);
				if (temp.hasOwnProperty("bottom")) target.y = getPosition(CSSKeyword.HEIGHT, temp.bottom, 1);
			}
			if (temp.hasOwnProperty("width")) target.width = getLength(CSSKeyword.WIDTH, temp.width);
			if (temp.hasOwnProperty("height")) target.height = getLength(CSSKeyword.HEIGHT, temp.height);
			if (temp.hasOwnProperty("alpha")) if (!isNaN(temp.alpha)) target.alpha = temp.alpha;
			
			return target;
		}
		
		public function get showStyle():String
		{
			return _show_style;
		}
		
		public function set showStyle(style:String):void
		{
			_show_style = style;
			
			var decoder:CSSDecoder = new CSSDecoder(_show_style);
			show_style_obj = decoder.getCSSObj();
			show_style = recount(show_style_obj);
		}
		
		public function getWidget(id:String):Widget
		{
			return widgets.getValueByKey(id) as Widget;
		}
		
		public function hasWidget(id:String):Boolean
		{
			return widgets.hasKey(id);
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
			mouseEnabled = enabled;
			if (enabled) mouseMove(null);
		}
		
		override protected function getDefinitionByName(url:String):Object
		{
			return ApplicationDomain.currentDomain.getDefinition(url);
		}
		
		
		
		protected var _hide_style:String;
		protected var _show_style:String;
		private var hide_style_obj:Object;
		private var show_style_obj:Object;
		private var _configuration:XML;
		
		protected var _assetsManager:AssetsManager;
		protected var _widgetManager:WidgetsManager;
		protected var backdrop:DisplayObject;
		protected var widgets:HashMap;
		protected var widgetClass:Vector.<String>
		
		public var tween:Tween;
		
		protected var rectangle:Rectangle;
		protected var size_mode:String;
		protected var r_x:Number = 0.0;
		protected var r_y:Number = 0.0;
		protected var r_w:Number = 0.0;
		protected var r_h:Number = 0.0;
		protected var _hide:Boolean;
		protected var _show:Boolean = true; //mark:此变量用于处理自动隐藏的异步问题。
		protected var _autoHide:Boolean;
		protected var _autoHideTimeout:int = 800;
		protected var autoHideTimer:Timer = null;
		protected var default_style:Object = { x:0, y:0, alpha:1 };
		protected var hide_style:Object = default_style;
		protected var show_style:Object = default_style;
		protected var _enabled:Boolean = true;
		//OVER
	}

}