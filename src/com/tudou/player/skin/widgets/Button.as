package com.tudou.player.skin.widgets 
{
	import com.tudou.player.skin.configuration.Keyword;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	/**
	 * Button 
	 */
	public class Button extends Sprite
	{
		
		public function Button( normal:DisplayObject
							  , focused:DisplayObject = null
							  , pressed:DisplayObject = null
							  , disabled:DisplayObject = null
							  )
		{
			this.normal = normal;
			this.focused = focused;
			this.pressed = pressed;
			this.disabled = disabled;
			
			this.mouseChildren = false;
			
			updateFace(this.normal);
			
			super();
		}
		
		// Internals
		//
		
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
		
		public function updateTxt(value:String):void
		{
			if(normal.hasOwnProperty('txt')) normal['txt'].text = value;
			if(focused && focused.hasOwnProperty('txt')) focused['txt'].text = value;
			if(pressed && pressed.hasOwnProperty('txt')) pressed['txt'].text = value;
			if(disabled && disabled.hasOwnProperty('txt')) disabled['txt'].text = value;
		}
		
		override public function set width(w:Number):void
		{
			normal.width = w;
			if(focused) focused.width = w;
			if(pressed) pressed.width = w;
			if(disabled) disabled.width = w;
			super.width = w;
		}
		
		override public function set height(h:Number):void
		{
			normal.height = h;
			if(focused) focused.height = h;
			if(pressed)pressed.height = h;
			if(disabled) disabled.height = h;
			super.height = h;
		}
		
		
		protected function onMouseDown(evt:MouseEvent):void
		{
			updateFace(this.pressed);
		}
		
		protected function onMouseUp(evt:MouseEvent):void
		{
			updateFace(this.focused);
		}
		
		protected function onRollOver(evt:MouseEvent):void
		{
			updateFace(this.focused);
		}
		
		protected function onRollOut(evt:MouseEvent):void
		{
			updateFace(this.normal);
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(i:int):void
		{
			_index = i;
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
			mouseEnabled = enabled;
			buttonMode = enabled;
			updateFace(enabled ? normal : disabled);
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
		
		private var currentFace:DisplayObject;
		protected var normal:DisplayObject;
		protected var focused:DisplayObject;
		protected var pressed:DisplayObject;
		protected var disabled:DisplayObject;
		private var _index:int;
		private var _id:String;
		
		private var _enabled:Boolean;
		protected var _label:String = "按 钮";
		
		protected static const NORMAL:String = Keyword.NORMAL;
		protected static const FOCUSED:String = Keyword.FOCUSED;
		protected static const PRESSED:String = Keyword.PRESSED;
		protected static const DISABLED:String = Keyword.DISABLED;
		
		/**
		 * 控制提示字体颜色
		 */
		public function get hintColor():uint
		{
			return hint_color;
		}
		
		public function set hintColor(color:uint):void
		{
			hint_color = color;
		}
		
		/**
		 * 控制提示
		 */
		public function get hintHasV():Boolean
		{
			return hint_has_v;
		}
		
		public function set hintHasV(has:Boolean):void
		{
			hint_has_v = has;
		}
		
		/**
		 * 控制提示x轴固定为某值
		 */
		public function get hintX():Number
		{
			return hint_x;
		}
		
		public function set hintX(num:Number):void
		{
			hint_x = num;
		}
		
		/**
		 * 控制提示y轴固定为某值
		 */
		public function get hintY():Number
		{
			return hint_y;
		}
		
		public function set hintY(num:Number):void
		{
			hint_y = num;
		}
		
		/**
		 * 控制提示
		 */
		public function get hintV():Number
		{
			return hint_v;
		}
		
		public function set hintV(num:Number):void
		{
			hint_v = num;
		}
		
		/**
		 * 控制提示
		 */
		public function get hintT():Number
		{
			return hint_t;
		}
		
		public function set hintT(num:Number):void
		{
			hint_t = num;
		}
		
		/**
		 * 控制提示可以鼠标划过交互
		 */
		public function get hintHover():Boolean
		{
			return hint_hover;
		}
		
		public function set hintHover(m:Boolean):void
		{
			hint_hover = m;
		}
		
		private var hint_color:uint;
		private var hint_has_v:Boolean = true;
		private var hint_x:Number;
		private var hint_y:Number;
		private var hint_v:Number;
		private var hint_t:Number;
		private var hint_hover:Boolean;
	}

}