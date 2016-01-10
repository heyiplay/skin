package com.tudou.player.skin.widgets 
{
	import com.tudou.layout.LayoutSprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * 开关按钮
	 * 
	 * @author 8088
	 */
	public class SwitchButton extends LayoutSprite
	{
		
		public function SwitchButton( on_normal:DisplayObject, off_normal:DisplayObject, on_focused:DisplayObject = null, off_focused:DisplayObject = null, on_disabled:DisplayObject = null, off_disabled:DisplayObject = null)
		{
			super();
			
			this.on_normal = on_normal;
			this.on_focused = on_focused;
			this.on_disabled = on_disabled;
			
			this.off_normal = off_normal;
			this.off_focused = off_focused;
			this.off_disabled = off_disabled;
			
			btn_w = on_normal.width;
			btn_h = on_normal.height;
			
			this.mouseChildren = false;
			
			updateFace(this.off_normal);
		}
		
		override protected function onStage(evt:Event=null):void
		{
			super.onStage(evt);
			
			style = "height:"+btn_h+"; width:" + btn_w + ";";
			
		}
		
		protected function onMouseDown(evt:MouseEvent):void
		{
			_mouse_on = true;
			_on = !_on;
			if (_on)
			{
				updateFace(on_focused);
			}
			else {
				updateFace(off_focused);
			}
		}
		
		protected function onRollOver(evt:MouseEvent):void
		{
			_mouse_on = true;
			var btn_face:DisplayObject;
			
			if (on) btn_face = on_focused;
			else btn_face = off_focused;
			
			updateFace(btn_face);
		}
		
		protected function onRollOut(evt:MouseEvent):void
		{
			_mouse_on = false;
			var btn_face:DisplayObject;
			
			if (on) btn_face = on_normal;
			else btn_face = off_normal;
			
			updateFace(btn_face);
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
		
		
		public function get on():Boolean 
		{
			return this._on;
		}
		
		public function set on(b:Boolean):void
		{
			this._on = b;
			
			if (_on)
			{
				if (enabled)
				{
					if(_mouse_on) updateFace(on_focused);
					else updateFace(on_normal);
				}
				else updateFace(on_disabled);
			}
			else {
				if(enabled) updateFace(off_normal);
				else updateFace(off_disabled);
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
							? on ? on_normal : off_normal
							: on ? on_disabled : off_disabled
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
		
		private var currentFace:DisplayObject;
		protected var on_normal:DisplayObject;
		protected var on_focused:DisplayObject;
		protected var on_disabled:DisplayObject;
		protected var off_normal:DisplayObject;
		protected var off_focused:DisplayObject;
		protected var off_disabled:DisplayObject;
		
		private var btn_w:Number;
		private var btn_h:Number;
		private var _on:Boolean;
		private var _mouse_on:Boolean;
		private var _enabled:Boolean;
		
	}

}