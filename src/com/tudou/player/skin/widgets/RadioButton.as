package com.tudou.player.skin.widgets 
{
	import com.tudou.layout.LayoutSprite;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * 单选按钮
	 * 
	 * @author 8088
	 */
	public class RadioButton extends LayoutSprite
	{
		public function RadioButton(label:String, normal:DisplayObject = null, check_normal:DisplayObject = null, focused:DisplayObject = null, check_focused:DisplayObject = null, disabled:DisplayObject = null, check_disabled:DisplayObject = null)
		{
			super();
			
			this.label = label;
			this.normal = normal;
			this.focused = focused;
			this.disabled = disabled;
			this.check_normal = check_normal;
			this.check_focused = check_focused;
			this.check_disabled = check_disabled;
			if(normal) btn_w = normal.width;
			if(normal) btn_h = normal.height;
			
			this.mouseChildren = false;
			
			updateFace(this.normal, normalColor);
			
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.font = "Verdana";
			
			label_txt = new TextField();
			label_txt.height = btn_h;
			label_txt.width = 0;
			label_txt.multiline = false;
			label_txt.wordWrap = false;
			label_txt.autoSize = "left";
			label_txt.defaultTextFormat = format;
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(null);
			
			label_txt.text = _label;
			if (this.normal) label_txt.x = btn_w;
			addChild(label_txt);
			
			style = "height:"+btn_h+"; width:" + label_txt.width + ";";
			
		}
		
		protected function updateFace(face:DisplayObject, color:uint):void
		{
			if (currentColor != color)
			{
				if(label_txt) label_txt.textColor = color;
			}
			
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
		
		protected function onMouseDown(evt:MouseEvent):void
		{
			if (!check)
			{
				_check = true;
				updateFace(check_focused, pressedColor);
			}
			
			_mouse_on = true;
		}
		
		protected function onRollOver(evt:MouseEvent):void
		{
			var btn_face:DisplayObject;
			
			if (check) btn_face = check_focused;
			else btn_face = focused;
			
			updateFace(btn_face, focusedColor);
			
			_mouse_on = true;
		}
		
		protected function onRollOut(evt:MouseEvent):void
		{
			var btn_face:DisplayObject;
			var btn_color:uint;
			
			if (check)
			{
				btn_face = check_normal;
				btn_color = pressedColor;
			}
			else {
				btn_face = normal;
				btn_color = normalColor;
			}
			
			updateFace(btn_face, btn_color);
			
			_mouse_on = false;
		}
		
		public function get check():Boolean 
		{
			return this._check;
		}
		
		public function set check(b:Boolean):void
		{
			this._check = b;
			if(enabled) mouseEnabled = !_check;
			if (_check)
			{
				if (enabled)
				{
					if(_mouse_on) updateFace(check_focused, pressedColor);
					else updateFace(check_normal, pressedColor);
				}
				else updateFace(check_disabled, disabledColor);
			}
			else {
				if(enabled) updateFace(normal, normalColor);
				else updateFace(disabled, disabledColor);
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
			mouseEnabled = enabled;
			buttonMode = enabled;
			updateFace( enabled 
							? check ? check_normal : normal
							: check ? check_disabled : disabled
					  , enabled ? normalColor : disabledColor
					  );
			
			if (enabled)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
			else {
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(l:String):void
		{
			_label = l;
			if (label_txt) label_txt.text = _label;
		}
		
		public function get textField():TextField
		{
			return label_txt;
		}
		
		protected var normal:DisplayObject;
		protected var focused:DisplayObject;
		protected var disabled:DisplayObject;
		protected var check_normal:DisplayObject;
		protected var check_focused:DisplayObject;
		protected var check_disabled:DisplayObject;
		protected var label_txt:TextField;
		protected var _check:Boolean;
		protected var _mouse_on:Boolean;
		
		private var btn_w:Number = 20;
		private var btn_h:Number = 20;
		private var _label:String = "";
		private var currentFace:DisplayObject;
		private var currentColor:uint;
		private var _enabled:Boolean;
		
		public var normalColor:uint = 0x999999;
		public var focusedColor:uint = 0xCCCCCC;
		public var pressedColor:uint = 0xEEEEEE;
		public var disabledColor:uint = 0x555555;
	}

}