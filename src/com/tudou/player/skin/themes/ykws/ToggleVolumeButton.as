package com.tudou.player.skin.themes.ykws
{
	import com.tudou.layout.LayoutSprite;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ToggleVolumeButton
	 * 
	 * @author sky
	 */
	public class ToggleVolumeButton extends LayoutSprite
	{
		protected var currentFace:DisplayObject;
		/**
		 * 当前按钮状态 
		 */		
		protected var _currIndex:int = 0;
		/**
		 * 缓存非0状态 
		 */		
		protected var _prevIndex:int = 0;
		
		protected var _enabled:Boolean;
		protected var _mouse_on:Boolean;
		
		private var btnArray:Array = [];
		
		public function ToggleVolumeButton( arr:Array )
		{
			super();
			
			btnArray = arr;
			if(arr[0]) style = "width:"+arr[0].width+"; height:" + arr[0].height + ";";
			
			this.mouseChildren = false;
			
			updateFace(arr[0]);
			
			_currIndex = 0;
		}
		
		protected function onMouseDown(evt:MouseEvent):void
		{
			//			if (_currIndex == 0) updateFace(btnArray[4 * _prevIndex + 2]);
			//			else updateFace(btnArray[4 * 0 + 2]);
			updateFace(btnArray[4 * _currIndex + 2])
		}
		
		protected function onMouseUp(evt:MouseEvent):void
		{
//			if (_currIndex == 0) _currIndex = _prevIndex;
//			else _currIndex = 0;
			updateFace(btnArray[4 * _currIndex + 1]);
		}
		
		protected function onRollOver(evt:MouseEvent):void
		{
			updateFace(btnArray[4 * _currIndex + 1]);
			_mouse_on = true;
		}
		
		protected function onRollOut(evt:MouseEvent):void
		{
			updateFace(btnArray[4 * _currIndex]);
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
		
		public function get toggle():int 
		{
			return _currIndex;
		}
		
		public function set toggle(value:int):void
		{
			if (_currIndex == value) return;
			
			_currIndex = value;
			if(_currIndex != 0) _prevIndex = _currIndex;
			if (enabled)
			{
				if(_mouse_on) updateFace(btnArray[4 * _currIndex + 1]);
				else updateFace(btnArray[4 * _currIndex ]);
			}
			else updateFace(btnArray[4 * _currIndex + 3]);
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
			
			updateFace( enabled ? btnArray[4 * _currIndex] : btnArray[4 * _currIndex + 3] );
			
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
	}
	
}