package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.layout.LayoutSprite;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.widgets.Hint;
	import com.tudou.player.skin.widgets.SliderBar;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.configuration.Keyword;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.utils.Timer;
	import com.tudou.utils.Scheduler;
	import com.tudou.events.SchedulerEvent;
	
	/**
	 * VolumeWidget
	 * 
	 * @author 8088
	 */
	public class VolumeWidget extends Widget
	{
		/**
		 * 音量按钮 
		 */		
		private var btn:ToggleVolumeButton;
		/**
		 * 静音标志 
		 */		
		private var _mute:Boolean;
		private var _volume:Number = 1.0;
		private var _default_volume:Number = 0.5;
		private var _old_volume:Number;
		private var _min_volume:Number = 0.05;
		
		private var extendArea:LayoutSprite;
		
		private var last_volume:Number = _default_volume;
		private var sliderBar:SliderBar;
		
		private var _normal_hint:String;
		private var _key_hint:String;
		/**
		 * 音量是否大于1 
		 */
		private var _hintStatus:Boolean = false;
		
		public function VolumeWidget() 
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
			
			var arr:Array = [];
			for(var i:int = 0; i<configuration.button.length(); i++)
			{
				var cofing:* = configuration.button[i].asset;
				arr.push(_assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id));
				arr.push(_assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id));
				arr.push(_assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id));
				arr.push(_assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id));
			}
			btn = new ToggleVolumeButton(arr);
			addChild(btn);
			_normal_hint = configuration.@alt;
			//_key_hint = _global.language.getString("H0004", NetStatusEventLevel.HINT );
			if (_key_hint == "" || _key_hint == "非常抱歉，检测到未知错误，请尝试刷新或联系客服。") _key_hint = _normal_hint;
			
			hintX = int(this.width * .5);
			hintY = -2;
			hintColor = 0xC5C5C5;
			//Scheduler.setTimeout(1, function(evt:SchedulerEvent):void { setVolume(_default_volume); } );
			setVolume(_default_volume);
			enabled = true;
		}
		/**
		 * 音量进度条 
		 * 
		 */		
		private function initExtendArea():void
		{
			extendArea = new LayoutSprite();
			extendArea.style = configuration.extendarea.@style;
			addChild(extendArea);
			
			sliderBar = new SliderBar
				( 
					_assetsManager.getDisplayObject(configuration.extendarea.sliderbar.asset.(@state == Keyword.TRACK).@id)
					, _assetsManager.getDisplayObject(configuration.extendarea.sliderbar.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(configuration.extendarea.sliderbar.asset.(@state == Keyword.FOCUSED).@id)
					,_assetsManager.getDisplayObject(configuration.extendarea.sliderbar.asset.(@state == Keyword.PRESSED).@id)
					,_assetsManager.getDisplayObject(configuration.extendarea.sliderbar.asset.(@state == Keyword.DISABLED).@id)
				);
			sliderBar.style = configuration.extendarea.sliderbar.@style;
			sliderBar.id = configuration.extendarea.sliderbar.@name;
			sliderBar.enabled = true;
			
			sliderBar.addEventListener(NetStatusEvent.NET_STATUS, sliderHandler);
			
			extendArea.addChild(sliderBar);
		}
		/**
		 * 进度条拖动事件 
		 * @param evt
		 * 
		 */		
		private function sliderHandler(evt:NetStatusEvent):void
		{
			var n:Number = Number(evt.info.data);
			setVolume(n);
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
					, false
					, false
					, { code:NetStatusCommandCode.SET_VOLUME, level:NetStatusEventLevel.COMMAND, data:{value:_volume, id:this.id, action:evt.info.action} }
				)
			);
		}
		/**
		 * 音量按钮down 
		 * @param evt
		 * 
		 */		
		private function downHandler(evt:MouseEvent):void
		{
			mute = !mute;
			
			var v:Number;
			if (mute)
			{
				last_volume = _volume;
				v = 0.0;
			}
			else {
				if (last_volume < _min_volume)
				{
					v = _default_volume;
				}
				else {
					v = last_volume;
				}
			}
			
			setVolume(v);
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
					, false
					, false
					, { code:NetStatusCommandCode.SET_VOLUME, level:NetStatusEventLevel.COMMAND, data:{value:_volume, id:this.id, action:evt.type} }
				)
			);
			_old_volume = _volume;
		}
		
		override protected function processEnabledChange():void
		{
			if (enabled)
			{
				btn.enabled = true;
				sliderBar.enabled = true;
				btn.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			}
			else {
				btn.enabled = false;
				sliderBar.enabled = false;
				btn.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			}
		}
		/**
		 * 皮肤即时音量设置 
		 * @param v
		 * 
		 */		
		private function setVolume(v:Number):void
		{
			_volume = int(v * 100) / 100;
			var b:Boolean = false;
			if (_volume < _min_volume) _volume = 0;
			if (_volume > 1) _volume = 1;
			if (_volume == 1) b = true;

			if(_volume == 0)
			{
				btn.toggle = 0;
			}else if(_volume > 0.5)
			{
				btn.toggle = 2;
			}else{
				btn.toggle = 1;
			}
			sliderBar.slide = _volume;
			
			if (b != _hintStatus)
			{
				_hintStatus = b;
				if (b)  this.title =  _key_hint;
				else this.title = _normal_hint;
				Hint.register(this, this.title);
				if(isMouseon()) Hint.text = this.title;
			}
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		/**
		 * 皮肤音量设置消息入口 
		 * @param n
		 * 
		 */		
		public function set volume(n:Number):void
		{
			var v:Number;
			if (n < _min_volume)
			{
				mute = true;
				v = 0;
			}
			else {
				mute = false;
				v = n;
			}
			
			setVolume(v);
			
			_old_volume = _volume;
		}
		
		public function get mute():Boolean
		{
			return _mute;
		}
		
		public function set mute(b:Boolean):void
		{
			_mute = b;
		}
	}
	
}