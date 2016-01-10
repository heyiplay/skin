package com.tudou.player.skin.widgets 
{
	import com.tudou.layout.LayoutSprite;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * 文本框
	 * 
	 * @author 8088
	 */
	public class TextBox extends LayoutSprite
	{
		
		public function TextBox(normal:DisplayObject, focused:DisplayObject=null, pressed:DisplayObject=null, disabled:DisplayObject=null) 
		{
			super();
			
			this.normal = normal;
			this.focused = focused;
			this.pressed = pressed;
			this.disabled = disabled;
			
			
			txt = new TextField();
			txt.height = 20;
			txt.x = 1;
			txt.width = 20;
			txt.multiline = false;
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(null);
			
			updateFace(this.normal);
			
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.font = "Arial";
			format.color = defaultColor;
			
			txt.defaultTextFormat = format;
			txt.type = defaultType;
			text = defaultText;
			addChild(txt);
		}
		
		protected function updateFace(face:DisplayObject):void
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
		}
		
		override protected function reSetWidth():void
		{
			if(normal) normal.width = this.width;
			if(focused) focused.width = this.width;
			if(pressed) pressed.width = this.width;
			if(disabled) disabled.width = this.width;
			if(txt) txt.width = this.width-2;
		}
		
		override protected function reSetHeight():void
		{
			if(normal) normal.height = this.height;
			if(focused) focused.height = this.height;
			if(pressed) pressed.height = this.height;
			if(disabled) disabled.height = this.height;
			if(txt) txt.y = int((this.height -txt.height) * .5);
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(t:String):void
		{
			_text = t;
			if (txt) txt.text = _text;
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
			updateFace(enabled ? normal : disabled);
			
			if (enabled)
			{
				txt.addEventListener(FocusEvent.FOCUS_IN, focusIn);
				txt.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
				txt.addEventListener(Event.CHANGE, textInput);
				addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
			else {
				txt.removeEventListener(FocusEvent.FOCUS_IN, focusIn);
				txt.removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
				txt.removeEventListener(Event.CHANGE, textInput);
				removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
		}
		
		protected function focusIn(evt:FocusEvent):void
		{
			_focus = true;
			updateFace(this.pressed);
		}
		
		protected function focusOut(evt:FocusEvent):void
		{
			_focus = false;
			updateFace(this.normal);
		}
		
		protected function textInput(evt:Event):void
		{
			_text = txt.text;
		}
		
		protected function onRollOver(evt:MouseEvent):void
		{
			if (_focus) return;
			updateFace(this.focused);
		}
		
		protected function onRollOut(evt:MouseEvent):void
		{
			if (_focus) return;
			updateFace(this.normal);
		}
		
		public function get textField():TextField
		{
			return txt;
		}
		
		public function get type():String
		{
			return txt.type;
		}
		
		public function set type(t:String):void
		{
			txt.type = t;
		}
		
		private var currentFace:DisplayObject;
		private var normal:DisplayObject;
		private var focused:DisplayObject;
		private var pressed:DisplayObject;
		private var disabled:DisplayObject;
		
		private var _enabled:Boolean;
		private var _focus:Boolean;
		
		private var txt:TextField;
		private var _text:String;
		public var defaultText:String = "";
		public var defaultColor:uint = 0xFFFFFF;
		public var defaultType:String = TextFieldType.INPUT;
		
	}

}