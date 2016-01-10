package com.tudou.player.skin.widgets
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	/**
	 * 引导式提示信息，使用注册的方式为显示对象实现提示功能。
	 * 默认10秒自动关闭，或手动关闭
	 */
	public class UserGuide extends Sprite
	{
		private static var _instance:UserGuide;
		private var call_list:Array = [];
		private var call_list_showed:Array = [];
		private var is_showing:Boolean = false;
		private var cur_index:int = 0;
		public static function getInstance():UserGuide
		{
			if(!_instance)
				_instance = new UserGuide();
			return _instance;
		}
		
		public function UserGuide()
		{
			init();
		}
		
		/**
		 * 初始化，整个容器Sprite，消息的TextField，关闭按钮的TextField和关闭按钮的容器
		 */
		private function init():void
		{
			_area = new Sprite();
			addChild(_area);
			
			//消息
			var format:TextFormat = new TextFormat();
			format.size = _size;
			format.align = TextFormatAlign.CENTER;
			format.font = "Arial";
			
			_label = new TextField();
			_label.x = 2;
			_label.y = 4;
			_label.height = 24;
			_label.width = 20;
			_label.multiline = true;
			_label.wordWrap = false;
			_label.defaultTextFormat = format;
			_label.textColor = DEFAULT_COLOR;
			_label.htmlText = DEFAULT_TEXT;
			_area.addChild(_label);
			
			//关闭按钮
			var xformat:TextFormat = new TextFormat();
			xformat.size = 12;
			xformat.align = TextFormatAlign.RIGHT;
			xformat.font = "Arial";
			xformat.bold = true;
			
			_closeBtn = new Sprite();
			_closeLabel = new TextField();
			_closeLabel.x = 0;
			_closeLabel.y = 4;
			_closeLabel.height = 24;
			_closeLabel.width = 14;
			_closeLabel.multiline = false;
			_closeLabel.wordWrap = false;
			_closeLabel.defaultTextFormat = xformat;
			_closeLabel.text = "X";
			_closeBtn.addChild(_closeLabel);
			_area.addChild(_closeBtn);
			_closeBtn.x = _label.x + _label.width;
			_closeBtn.y = 0;
			_closeBtn.addEventListener(MouseEvent.MOUSE_OVER, closeBtnMouseOverHlr);
			_closeBtn.addEventListener(MouseEvent.MOUSE_OUT, closeBtnMouseOutHlr);
			_closeBtn.addEventListener(MouseEvent.ROLL_OVER, closeBtnMouseOverHlr);
			_closeBtn.addEventListener(MouseEvent.ROLL_OUT, closeBtnMouseOutHlr);
			_closeBtn.addEventListener(MouseEvent.MOUSE_UP, closeBtnMouseUpHlr);
			updateCloseBtnStatus(false);
			
			//鼠标响应设置
			_label.mouseEnabled = false;
			_closeBtn.buttonMode = true;
			_closeLabel.mouseEnabled = false;
			
			drawBg();
		}
		/**
		 * 为某一个对象显示提示
		 * @param	viewObj         为谁显示提示
		 * @param	txt             提示的内容
		 * @param	lx              提示的x轴注册点
		 * @param	ly              提示的Y轴注册点
		 * @param	closeHintHlr    关闭提示时的回调函数 默认为null
		 * @param	autoClose		是否自动关闭 默认为true
		 * @param	type			提示信息类型
		 * @param	once			是否只能显示一次
		 */
		public function show(viewObj:DisplayObjectContainer, txt:String, lx:Number, ly:Number, closeHintHlr:Function = null, autoClose:Boolean = true, type:String = "one guide", once:Boolean = true):void
		{
			call_list.push([viewObj, txt, lx, ly, closeHintHlr, autoClose, type, once]);
			call_list_showed.push(false);
			
			if(!is_showing)
			{
				cur_index = call_list.length-1;
				showGuid.apply(this, call_list[cur_index]);
			}
		}
		//显示了一个继续显示队列中下一个
		private function gotoNext():void
		{
			if(!is_showing)
			{
				//修改当前为已显示
				call_list_showed[cur_index] = true;
				
				//下一个
				cur_index++;
				if(cur_index >= call_list.length) return;
				showGuid.apply(this, call_list[cur_index]);
			}
		}
		
		private function showGuid(viewObj:DisplayObjectContainer, txt:String, lx:Number, ly:Number, closeHintHlr:Function = null, autoClose:Boolean = true, type:String = "one guide", once:Boolean = true):void
		{
			if (!viewObj)
			{
				throw new ArgumentError("viewObj 不能为 null！！");
			}
			
			if (once)
			{
				var checkGuide:CheckGuide = new CheckGuide();
				var isShowed:Boolean = checkGuide.judge(type);
				if (isShowed)
				{
					gotoNext();
					return;
				}
			}
			
			_view = viewObj;
			_text = txt;
			_closeFn = closeHintHlr;
			_label.htmlText  = _text;
			_label.width = _label.textWidth + _size;
			_label.height = _label.textHeight + _size;
			_closeBtn.x = _label.x + _label.width;
			arrowX = lx;
			arrowY = ly;
			
			if(_view.x + arrowX + this.width / 2 > _view.parent.width)
			{
				this.x = arrowX - (this.width - _view.parent.width + _view.x + arrowX);
			}
			else if(_view.x + arrowX < this.width / 2) {
				this.x = -_view.x;
			}
			else {
				this.x = arrowX - this.width / 2;
			}
			
			this.y = arrowY - this.height - _t_h;
			
			drawBg();
			
			is_showing = true;
			
			_view.addChild(this);
			
			if (!visible) visible = true;
			
			if (autoClose) startTimer();
		}
		
		/**
		 * 隐藏并删除提示
		 */
		public function hide():void
		{
			destroyTimer();
			
			visible = false;
			
			if (_view)
			{
				if (_view.contains(this)) _view.removeChild(this);
				
				arrowX = Number.NaN;
				arrowY = Number.NaN;
				_label.textColor = DEFAULT_COLOR;
				_label.htmlText = _text = DEFAULT_TEXT;
				_label.width = _label.textWidth + _size;
				_closeBtn.x = _label.x + _label.width;
			}
			graphics.clear();
			
			is_showing = false;
			gotoNext();
		}
		
		public function set delay(value:int):void
		{
			CLOSING_DELAY = value;
		}
		
		private var _t_w:Number = 13; //三角形的宽
		private var _t_h:Number = 9; //三角形的高
		
		private function drawBg():void
		{
			var _x:int = int(_area.x);
			var _y:int = int(_area.y);
			var _w:int = int(_area.width);
			var _h:int = int(_area.height);
			
			graphics.clear();
			graphics.beginFill(0x222222, 1);
			graphics.drawRect(_x, _y, _w + 4, _h + 4);
			
			graphics.beginFill(0x222222, 1);
			graphics.drawRect(_x + 1, _y + 1, _w + 2, _h + 2);
			
			graphics.beginFill(0x222222, 1);
			graphics.drawRect(_x + 2, _y + 2, _w, _h);
			graphics.endFill();
			
			if (!_view)
				return;
			
			var vector:Vector.<Number>;
			var p1:Point = new Point();
			var p2:Point = new Point();
			var p3:Point = new Point();
			//_v=1 _t=1为箭头向下  _v=0 _t=-1为箭头向上
			var _v:int = 1;
			var _t:int = 1;
			
			p1.x = arrowX - this.x;
			p2.x = p1.x - _t_w * .5;
			p3.x = p1.x + _t_w * .5;
			
			p1.y = _h * _v + _t_h * _t + 2;
			p2.y = p1.y + _t_h * (-_t);
			p3.y = p1.y + _t_h * (-_t);
			
			vector = new Vector.<Number>();
			vector.push(p1.x, p1.y + _t);
			vector.push(p2.x - 1, p2.y + _t);
			vector.push(p3.x + 1, p3.y + _t);
			
			graphics.beginFill(0x222222, 1);
			graphics.drawTriangles(vector);
			
			vector = new Vector.<Number>();
			vector.push(p1.x, p1.y);
			vector.push(p2.x, p2.y);
			vector.push(p3.x, p3.y);
			
			graphics.beginFill(0x222222, 1);
			graphics.drawTriangles(vector);
			
			graphics.endFill();
		
		}
		
		private function closeBtnMouseOverHlr(evt:MouseEvent):void
		{
			updateCloseBtnStatus(true);
		}
		
		private function closeBtnMouseOutHlr(evt:MouseEvent):void
		{
			updateCloseBtnStatus(false);
		}
		
		private function closeBtnMouseUpHlr(evt:MouseEvent):void
		{
			onClosingTimerComplete(null);
		}
		
		private function updateCloseBtnStatus(isMouseOver:Boolean):void
		{
			var bgColor:uint;
			var bgAlph:Number;
			
			if (isMouseOver)
			{
				_closeLabel.textColor = 0xFFFFFF;
				bgColor = 0xFFFFFF;
				bgAlph = 0.02;
			}
			else
			{
				_closeLabel.textColor = 0xC1C1C1;
				bgColor = 0x000000;
				bgAlph = 0;
			}
			
			var closeBtnG:Graphics = _closeBtn.graphics;
			closeBtnG.clear();
			closeBtnG.beginFill(bgColor, bgAlph);
			closeBtnG.drawRect(0, 4, _closeLabel.width + 3, _area.height - 4);
			closeBtnG.endFill();
		}
		
		private function startTimer():void
		{
			destroyTimer();
			
			closingTimer = new Timer(CLOSING_DELAY, 1);
			closingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onClosingTimerComplete);
			closingTimer.start();
		}
		
		private function destroyTimer():void
		{
			if (closingTimer != null)
			{
				closingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onClosingTimerComplete);
				closingTimer.stop();
				closingTimer = null;
			}
		}
		
		private function onClosingTimerComplete(evt:TimerEvent):void
		{
			destroyTimer();
			
			if (null != _closeFn)
				_closeFn.apply(_view);
			hide();
		}
		
		private var _view:DisplayObjectContainer;
		private var _text:String = "";
		
		private var _closeFn:Function;
		
		private var _label:TextField;
		private var _closeBtn:Sprite;
		private var _closeLabel:TextField;
		private var _area:Sprite;
		private var _size:Number = 12;
		
		private var arrowX:Number; //箭头在对应的显示对象里面的X轴坐标
		private var arrowY:Number; //箭头在对应的显示对象里面的Y轴坐标
		
		private var closingTimer:Timer;
		private var CLOSING_DELAY:uint = 10000; //10s
		
		private const DEFAULT_TEXT:String = "";
		private const DEFAULT_COLOR:uint = 0xFFFFFF;
	}
}

class CheckGuide
{
	private var tudouSo:CookieInterface;
	
	public function CheckGuide()
	{
		tudouSo = new CookieInterface("TudouData");
	}
	
	/**
	 * 判断是否已经展示过
	 * @param	type 引导提示类型
	 * @return	true为已展示过
	 */
	public function judge(type:String):Boolean
	{
		var guideObject:Object = tudouSo.getValue("guide");
		if (guideObject)
		{
			if (guideObject.hasOwnProperty(type) && guideObject[type])
			{
				return true;
			}
		}
		else
		{
			guideObject = new Object();
		}
		guideObject[type] = true;
		
		tudouSo.setValue("guide", guideObject);
		return false;
	}
}

import flash.net.SharedObject;

class CookieInterface
{
	protected var sharedObj:SharedObject;
	protected var locking:Boolean = false;
	
	public function CookieInterface(name:String)
	{
		sharedObj = SharedObject.getLocal(name, "/");
	}
	
	public function setValue(name:String, value:*):void
	{
		sharedObj.data[name] = value;
		flush();
	}
	
	public function getValue(name:String):*
	{
		try
		{
			return sharedObj.data[name];
		}
		catch (error:Error)
		{
			trace(error);
		}
		
		return null;
	}
	
	public function deleteValue(name:String):void
	{
		try
		{
			sharedObj.data[name] = null;
			delete sharedObj.data[name];
			flush();
		}
		catch (error:Error)
		{
			trace(error);
		}
	}
	
	public function clear():void
	{
		sharedObj.clear();
	}
	
	public function lock():void
	{
		locking = true;
	}
	
	public function unlock():void
	{
		locking = false;
		flush();
	}
	
	public function size():int
	{
		return sharedObj.size;
	}
	
	private function flush():void
	{
		try
		{
			if (!locking)
			{
				sharedObj.flush();
			}
		}
		catch (error:Error)
		{
			trace(error);
		}
	}
}