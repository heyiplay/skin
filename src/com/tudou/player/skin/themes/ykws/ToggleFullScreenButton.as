package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.events.SchedulerEvent;
	import com.tudou.events.TweenEvent;
	import com.tudou.layout.LayoutSprite;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.configuration.SizeMode;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.themes.ykws.ExtendToggleScreenButton;
	import com.tudou.utils.Check;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Hint;
	import com.tudou.utils.Scheduler;
	import com.tudou.utils.Tween;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	/**
	 * ToggleFullScreenButton
	 */
	public class ToggleFullScreenButton extends Widget
	{
		
		public function ToggleFullScreenButton() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			if (configuration && configuration.extendarea.length()>0)
			{
				initExtendArea();
			}
			
			var cofing:XMLList;
			
			cofing = configuration.button.(@id == "FullScreenEnterButton").asset.(hasOwnProperty("@state"));
			enter_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			enter_btn.id = SizeMode.FULL_SCREEN;
			addChild(enter_btn);
			
			_open_hint = configuration.button.(@id == "FullScreenEnterButton").@alt;
			
			
			cofing = configuration.button.(@id == "FullScreenLeaveButton").asset.(hasOwnProperty("@state"));
			leave_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			leave_btn.id = SizeMode.NORMAL;
			addChild(leave_btn);

			
			_close_hint = configuration.button.(@id == "FullScreenLeaveButton").@alt;
			hintX = int(this.width * .5);
			hintY = -2;
			hintColor = 0xC5C5C5;
			
			fullScreen = false;
			enabled = true;
			//mode = Keyword.POPUP;//只有弹出窗口播放模式才会在播放器外部设置设置此参数。
			mode = SizeMode.NARROW_SCREEN;
		}
		
		private function initExtendArea():void
		{
			extendArea = new LayoutSprite();
			extendArea.style = configuration.extendarea.@style;
			addChild(extendArea);
			
			rectangle = new Rectangle(0, -10, this.width -1, extendArea.height +this.height);
			
			tween = new Tween(extendArea);
			
			var btn_len:int = configuration.extendarea.button.length();
			
			btns = { };
			for (var i:int = 0; i != btn_len; i++)
			{
				var btn_config:XML = configuration.extendarea.button[i];
				var id:String = btn_config.@id;
				
				var cofing:XMLList = btn_config.asset.(hasOwnProperty("@state"));
				
				var btn:ExtendToggleScreenButton= new ExtendToggleScreenButton
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
					
				btn.id = id;
				btn.y = extendArea.height - (btn.height * (i + 1)) - (2 * i);
				btn.enabled = true;
				btns[id] = btn;
				extendArea.addChild(btn);
				
				btn.addEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			var btn:ExtendToggleScreenButton = evt.target as ExtendToggleScreenButton;
			if (btn.id != SizeMode.POPUP)
			{
				setCur(btn.id);
				old_set = btn.id;
			}
			fullScreen = false;
			dispatch(btn.id);
		}
		
		private function onClick(evt:Event):void
		{
			if (stage) {
				
				fullScreen = (_global.status.displayState == StageDisplayState.FULL_SCREEN);
				
				var btn:Button = evt.target as Button;
				
				dispatch(btn.id);
			}
		}
		
		private function dispatch(id:String):void
		{
			var command_code:String = "";
			switch(id)
			{
				case SizeMode.FULL_SCREEN:
				case SizeMode.FULL_SCREEN_INTERACTIVE:
					command_code = NetStatusCommandCode.SET_PLAYER_SIZE_FULLSCREEN;
					break;
				case SizeMode.NORMAL:
					command_code = NetStatusCommandCode.SET_PLAYER_SIZE_NORMAL;
					break;
				case SizeMode.NARROW_SCREEN:
					command_code = NetStatusCommandCode.SET_PLAYER_SIZE_NARROWSCREEN;
					break;
				case SizeMode.WIDE_SCREEN:
					command_code = NetStatusCommandCode.SET_PLAYER_SIZE_WIDECREEN;
					break;
				case SizeMode.POPUP:
					command_code = NetStatusCommandCode.SET_PLAYER_SIZE_POPUP;
					break;
			}
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:command_code, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, action:MouseEvent.CLICK }}
				)
			);
		}
		
		private function show():void
		{
			extendArea.visible = true;
			tween.pause();
			tween.easeOut().fadeIn(500);
		}
		
		private function hidden():void
		{
			tween.pause();
			tween.fadeOut(200);
			tween.addEventListener(TweenEvent.END, hiddenHandler);
		}
		
		private function hiddenHandler(evt:TweenEvent):void
		{
			tween.removeEventListener(TweenEvent.END, hiddenHandler);
			extendArea.visible = false;
		}
		
		private function onMouseOver(evt:MouseEvent):void
		{
			if (extendArea) show();
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			if (extendArea) checkMouseAway();
		}
		
		private function onMouseLeave(evt:Event):void
		{
			if (extendArea) {
				hidden();
			}
		}
		
		private function checkMouseAway():void
		{
			var point:Point = new Point(extendArea.mouseX, extendArea.mouseY);
			var mouse_away:Boolean = Check.Out(point, rectangle);
			if (mouse_away) hidden();
			else{
				Scheduler.setTimeout(250, hiddenTimeOut);
			}
		}
		
		private function hiddenTimeOut(evt:SchedulerEvent):void
		{
			checkMouseAway();
		}
		
		public function set fullScreen(b:Boolean):void {
			
			_fullScreen = b;
			
			if (extendArea)
			{
				if (_fullScreen)
				{
					for each(var _btn:ExtendToggleScreenButton in btns)
					{
						if (_btn) _btn.cur = false;
					}
				}
				else {
					setCur(old_set);
				}
			}
			
			if (fullScreen) 
			{
				this.title = _close_hint;
				
				var str:String = configuration.@fullbackground;
				this.parent["style"] = str;
			}else
			{
				this.title = _open_hint;
			}
			Hint.register(this, this.title);
			//mark:全屏按钮即时改变 会在全屏执行时闪现提示，
			//if(isMouseon()) Hint.text = this.title;
			Hint.text = "";
			
			if (leave_btn) leave_btn.visible = _fullScreen;
			if (enter_btn) enter_btn.visible = !_fullScreen;
			
		}
		
		public function get fullScreen():Boolean
		{
			return _fullScreen;
		}
		
		private function setCur(id:String):void
		{
			if (!btns) return;
			var btn:ExtendToggleScreenButton = btns[id] as ExtendToggleScreenButton;
			if (!btn) return;
			for each(var _btn:ExtendToggleScreenButton in btns)
			{
				if (_btn) _btn.cur = false;
			}
			
			btn.cur = true;
		}
		
		public function get mode():String
		{
			return old_set;
		}
		
		public function set mode(id:String):void
		{
			if (mode == id) return;
			switch(id)
			{
				case SizeMode.FULL_SCREEN:
				case SizeMode.FULL_SCREEN_INTERACTIVE:
					fullScreen = true;
					break;
				case SizeMode.NORMAL:
				case SizeMode.NARROW_SCREEN:
				case SizeMode.WIDE_SCREEN:
				case SizeMode.POPUP:
					fullScreen = false;
					break;
				default:
					throw new Error("无此尺寸设置模式：" + id);
					break;
				
			}
			
			setCur(id);
			if (id == SizeMode.POPUP)
			{
				for each(var _btn:ExtendToggleScreenButton in btns)
				{
					if (_btn.id != SizeMode.POPUP)_btn.enabled = false;
				}
			}
			
			old_set = id;
		}
		
		override protected function processEnabledChange():void
		{
			if (enabled)
			{
				enter_btn.enabled = true;
				enter_btn.addEventListener(MouseEvent.CLICK, onClick);
				leave_btn.enabled = true;
				leave_btn.addEventListener(MouseEvent.CLICK, onClick);
				
				if (extendArea) addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				if (extendArea) addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				if (stage) stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			}
			else {
				enter_btn.enabled = false;
				enter_btn.removeEventListener(MouseEvent.CLICK, onClick);
				leave_btn.enabled = false;
				leave_btn.removeEventListener(MouseEvent.CLICK, onClick);
				
				if (extendArea) removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				if (extendArea) removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				if (stage) stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			}
		}
		
		private var enter_btn:Button;
		private var leave_btn:Button;
		
		private var _fullScreen:Boolean;
		
		private var extendArea:LayoutSprite;
		private var rectangle:Rectangle;
		private var tween:Tween;
		
		private var btns:Object;
		private var old_set:String;
		private var _open_hint:String;
		private var _close_hint:String;
	}

}
