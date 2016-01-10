package com.tudou.player.skin.widgets 
{
	import com.tudou.layout.LayoutSprite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * LabelButton
	 * 
	 * @author 8088
	 */
	public class LabelButton extends LayoutSprite
	{
		
		public function LabelButton( label:String
									, normal:DisplayObject = null
									, focused:DisplayObject = null
									, pressed:DisplayObject = null
									, disabled:DisplayObject = null
									, normalColor:uint = 0xCCCCCC
									, focusedColor:uint = 0xFFFFFF
									, pressedColor:uint = 0xFFFFFF
									, disabledColor:uint = 0x666666
									)
		{
			super();
			
			this.label = label;
			this.normal = normal || new Normal();
			this.focused = focused || new Focused();
			this.pressed = pressed || new Pressed();
			this.disabled = disabled || new Disabled();
			
			this.normalColor = normalColor;
			this.focusedColor = focusedColor;
			this.pressedColor = pressedColor;
			this.disabledColor = disabledColor;
			
			this.mouseChildren = false;
			
			updateFace(this.normal, this.normalColor);
			
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.align = TextFormatAlign.CENTER;
			format.font = "Arial";
			format.color = 0xffffff;
			
			label_txt = new TextField();
			label_txt.height = 20;
			label_txt.width = 20;
			label_txt.multiline = false;
			label_txt.defaultTextFormat = format;
			
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(null);
			
			label_txt.text = _label;
			
			addChild(label_txt);
			
		}
		
		override protected function getDefinitionByName(url:String):Object
		{
			return ApplicationDomain.currentDomain.getDefinition(url);
		}
		
		override protected function reSetWidth():void
		{
			normal.width = this.width;
			focused.width = this.width;
			pressed.width = this.width;
			disabled.width = this.width;
			label_txt.width = this.width;
		}
		
		override protected function reSetHeight():void
		{
			normal.height = this.height;
			focused.height = this.height;
			pressed.height = this.height;
			disabled.height = this.height;
			label_txt.y = int((this.height -label_txt.height) * .5);
		}
		
		protected function updateFace(face:DisplayObject, color:uint):void
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
					addChildAt(currentFace, 0);
				}
			}
			
			if (currentColor != color)
			{
				if(label_txt) label_txt.textColor = color;
			}
		}
		
		protected function onMouseDown(evt:MouseEvent):void
		{
			updateFace(this.pressed, pressedColor);
		}
		
		protected function onMouseUp(evt:MouseEvent):void
		{
			updateFace(this.focused, focusedColor);
		}
		
		protected function onRollOver(evt:MouseEvent):void
		{
			updateFace(this.focused, focusedColor);
		}
		
		protected function onRollOut(evt:MouseEvent):void
		{
			updateFace(this.normal, normalColor);
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
			buttonMode = enabled;
			updateFace(enabled ? normal : disabled, enabled ? normalColor : disabledColor);
			
			if (enabled)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			else {
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
				removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(l:String):void
		{
			_label = l;
			if(label_txt) label_txt.text = _label;
		}
		
		public function get textField():TextField
		{
			return label_txt;
		}
		
		protected var normal:DisplayObject;
		protected var focused:DisplayObject;
		protected var pressed:DisplayObject;
		protected var disabled:DisplayObject;
		protected var label_txt:TextField;
		
		private var _label:String = "按 钮";
		private var currentFace:DisplayObject;
		private var currentColor:uint;
		private var _enabled:Boolean;
		
		public var normalColor:uint = 0xCCCCCC;
		public var focusedColor:uint = 0xFFFFFF;
		public var pressedColor:uint = 0xFFFFFF;
		public var disabledColor:uint = 0x666666;
	}
	
}
import flash.display.Shape;

class Pic extends Shape
{
	public function Pic():void
	{
		this.graphics.beginFill(_c, _a);
		this.graphics.drawRect(0, 0, 20, 20);
		this.graphics.endFill();
	}
	
	override public function set width(w:Number):void
	{
		_w = w;
		this.graphics.clear();
		this.graphics.beginFill(_c, _a);
		this.graphics.drawRect(0, 0, _w, _h);
		this.graphics.endFill();
		super.width = _w;
		
	}
	override public function set height(h:Number):void
	{
		_h = h;
		this.graphics.clear();
		this.graphics.beginFill(_c, _a);
		this.graphics.drawRect(0, 0, _w, _h);
		this.graphics.endFill();
		super.height = _h;
	}
	
	protected var _w:Number = 0.0;
	protected var _h:Number = 0.0;
	protected var _c:uint = 0;
	protected var _a:Number = 0;
	
}

class Normal extends Pic
{
	public function Normal():void
	{
		_c = 0;
		_a = 0;
		super();
	}
}

class Focused extends Pic
{
	public function Focused():void
	{
		_c = 0xFFFFFF;
		_a = 0.01;
		super();
	}
}

class Pressed extends Pic
{
	public function Pressed():void
	{
		_c = 0;
		_a = 0.05;
		super();
	}
}

class Disabled extends Pic
{
	public function Disabled():void
	{
		_c = 0;
		_a = 0;
		super();
	}
}