package com.tudou.player.skin.widgets 
{
	import com.tudou.player.skin.widgets.Widget;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.events.Event;
	import flash.events.FocusEvent;
	/**
	 * Label
	 */
	public class Label extends Widget
	{
		
		public function Label() 
		{
			super();
			
			_textField = new TextField();
			_textField.width = 20;
			_textField.height = 20;
			addChild(_textField);
			
			var format:TextFormat = new TextFormat();
			format.align = align;
			format.bold = bold;
			format.color = color;
			format.font = font;
			format.size = size;
			_textField.defaultTextFormat = format;
			
			textFormat = format;
		}
		
		private function onChange(event:Event):void
		{
			dirty = true;
		}
		
		private function onFocusIn(event:FocusEvent):void
		{
			if (textField.text == defaultText && !dirty)
			{
				textField.text = "";
				textField.displayAsPassword = password;
			}
		}
		
		private function onFocusOut(event:FocusEvent):void
		{
			if (textField.text == "" && defaultText.length > 0)
			{
				textField.text = defaultText;
				textField.displayAsPassword = false;
				dirty = false;
			}
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			if (width == 0) style = "width:" + (textWidth+4) + "; height:" + 20 + ";";
			
			textField.type = input ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			textField.selectable = textField.type == TextFieldType.INPUT || selectable;
			textField.displayAsPassword = password;
			textField.multiline = multiline;
			textField.border = border;
			textField.borderColor = borderColor;
			textField.background = background;
			textField.backgroundColor = backgroundColor;
			textField.wordWrap = textField.multiline;
			textField.embedFonts = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.sharpness = 200;
			textField.thickness = 0;
			if(textField.text == "")
			{
				textField.text = defaultText;
				textField.displayAsPassword = false;
			}
			if (input)
			{
				textField.addEventListener(Event.CHANGE, onChange);
				textField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
				textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			}
		}
		
		public function focus():void
		{
			stage.focus = textField;
		}
		
		public function get text():String
		{
			return textField.text;
		}
		
		public function set text(value:String):void
		{
			var oldText:String = textField.text;
			
			textField.text = value;
			textFormat = textFormat;
		}
		
		public function get htmlText():String
		{
			var html_txt:String;
			html_txt= textField.htmlText;
			return html_txt;
		}
		
		public function set htmlText(value:String):void
		{
			if (textField) 
			{
				var oldText:String = textField.htmlText;
				textField.setTextFormat(textFormat);
				textField.htmlText = value;
			}
			
		}
		
		public function get textWidth():Number
		{
			return textField.textWidth;
		}
		
		public function get textHeight():Number
		{
			return textField.textHeight;
		}
		
		override public function set width(w:Number):void
		{
			textField.width = w;
			super.width = w;
		}
		override public function set height(h:Number):void
		{
			textField.height = h;
			super.height = h;
		}
		
		
		
		
		
		public function get size():uint
		{
			return _size;
		}
		
		public function set size(s:uint):void
		{
			_size = s;
			
			textFormat.size = _size;
			textFormat = textFormat;
		}
		
		public function get font():String
		{
			return _font;
		}
		
		public function set font(f:String):void
		{
			_font = f;
			textFormat.font = _font;
			textFormat = textFormat;
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(c:uint):void
		{
			_color = c;
			textFormat.color = _color;
			textFormat = textFormat;
		}
		
		public function get bold():Boolean
		{
			return _bold;
		}
		
		public function set bold(b:Boolean):void
		{
			_bold = b;
			textFormat.bold = _bold;
			textFormat = textFormat;
		}
		
		public function get align():String
		{
			return _align;
		}
		
		public function set align(a:String):void
		{
			_align = a;
			textFormat.align = _align;
			textFormat = textFormat;
		}
		
		public function get leading():Object
		{
			return _leading;
		}
		
		public function set leading(l:Object):void
		{
			_leading = l;
			textFormat.leading = _leading;
			textFormat = textFormat;
		}
		
		/**
		 * 获取文本格式
		 * 
		 */
		public function get textFormat():TextFormat
		{
			return _textFormat;
		}
		
		public function set textFormat(format:TextFormat):void
		{
			_textFormat = format
			textField.setTextFormat(_textFormat);
		}
		
		/**
		 * 获取文本对象
		 * 
		 */
		public function get textField():TextField
		{
			return _textField;
		}
		
		
		private var dirty:Boolean;
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		private var _align:String = "left";
		private var _bold:Boolean = false;
		private var _color:uint = 0xFFFFFF;
		private var _font:String = "Verdana";
		private var _size:uint = 12;
		private var _leading:Object;
		
		public var input:Boolean;
		public var border:Boolean;
		public var borderColor:uint;
		public var background:Boolean;
		public var backgroundColor:uint;
		public var selectable:Boolean;
		public var password:Boolean;
		public var multiline:Boolean;
		public var defaultText:String = "";
	}

}