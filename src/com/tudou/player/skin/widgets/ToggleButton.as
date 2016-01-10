package com.tudou.player.skin.widgets 
{
	import com.tudou.layout.LayoutSprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * SwitchButton
	 * 
	 * @author 8088
	 */
	public class ToggleButton extends LayoutSprite
	{
		
		public function ToggleButton( one_normal:DisplayObject
									, two_normal:DisplayObject
									, one_focused:DisplayObject = null
									, two_focused:DisplayObject = null
									, one_pressed:DisplayObject = null
									, two_pressed:DisplayObject = null
									, one_disabled:DisplayObject = null
									, two_disabled:DisplayObject = null
									)
		{
			super();
			
			this.one_normal = one_normal;
			this.one_focused = one_focused;
			this.one_pressed = one_pressed;
			this.one_disabled = one_disabled;
			
			this.two_normal = two_normal;
			this.two_focused = two_focused;
			this.two_pressed = two_pressed;
			this.two_disabled = two_disabled;
			
			if(one_normal) style = "width:"+one_normal.width+"; height:" + one_normal.height + ";";
			
			this.mouseChildren = false;
			
			updateFace(this.one_normal);
			
			_toggle = true;
		}
		
		protected function onMouseDown(evt:MouseEvent):void
		{
			if (_toggle) updateFace(one_pressed);
			else updateFace(two_pressed);
		}
		
		protected function onMouseUp(evt:MouseEvent):void
		{
			_toggle = !_toggle;
			if (_toggle) updateFace(one_focused);
			else updateFace(two_focused);
		}
		
		protected function onRollOver(evt:MouseEvent):void
		{
			if (_toggle) updateFace(one_focused);
			else updateFace(two_focused);
			_mouse_on = true;
		}
		
		protected function onRollOut(evt:MouseEvent):void
		{
			if (_toggle) updateFace(one_normal);
			else updateFace(two_normal);
			_mouse_on = false;
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
		
		public function get toggle():Boolean 
		{
			return _toggle;
		}
		
		public function set toggle(value:Boolean):void
		{
			if (_toggle == value) return;
			
			_toggle = value;
			
			if (_toggle)
			{
				if (enabled)
				{
					if(_mouse_on) updateFace(one_focused);
					else updateFace(one_normal);
				}
				else updateFace(one_disabled);
			}
			else {
				if(enabled) updateFace(two_normal);
				else updateFace(two_disabled);
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
							? _toggle ? one_normal : two_normal
							: _toggle ? one_disabled : two_disabled
					  );
			
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
		
		protected var one_normal:DisplayObject;
		protected var one_focused:DisplayObject;
		protected var one_pressed:DisplayObject;
		protected var one_disabled:DisplayObject;
		protected var two_normal:DisplayObject;
		protected var two_focused:DisplayObject;
		protected var two_pressed:DisplayObject;
		protected var two_disabled:DisplayObject;
		
		protected var currentFace:DisplayObject;
		protected var _toggle:Boolean;
		protected var _enabled:Boolean;
		protected var _mouse_on:Boolean;
		
	}
	
}