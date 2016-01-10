package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.events.SchedulerEvent;
	import com.tudou.events.TweenEvent;
	import com.tudou.layout.LayoutSprite;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.utils.ArrayUtil;
	import com.tudou.utils.Check;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.assets.FontAsset;
	import com.tudou.utils.Scheduler;
	import com.tudou.utils.Tween;
	import com.tudou.utils.Utils;
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	
	/**
	 * ToggleQualityButton
	 * - 原切换清晰度控件（ToggleClarityButton）的升级版
	 * - 按钮、和扩展按钮升级为LabelButton，字体颜色四态外部控制。
	 * - 皇冠标志提到外部接口配置
	 * 
	 * @author 8088
	 */
	public class ToggleQualityButton extends Widget
	{
		
		private var setMap:Object = {"低清":"small", "标清":"320p", "高清":"480p", "超清":"720p", "1080P":"1080p" };
		private var getMap:Object = {"small":"低清", "320p":"标清", "480p":"高清", "720p":"超清", "1080p":"1080P" };
		
		public function ToggleQualityButton() 
		{
			super();
		}
		
		public function get quality():String
		{
			return _quality;
		}
		
		public function set quality(value:String):void
		{
			if (_quality == value) return;
			
			setCur(value);
			
			setQuality(value);
			
			_quality = value;
		}
		
		public function get qualityArray():Array
		{
			return _quality_array;
		}
		
		public function set qualityArray(ary:Array):void
		{
			if (ArrayUtil.equals(_quality_array, ary)) return;
			
			claritys = [];
			for (var i:int; i != ary.length; i++)
			{
				claritys.push(getMap[ary[i]]);
			}
			
			btn_len = claritys.length;
			
			if (btn_len > 1)
			{
				initExtendArea();
			}
			else {
				enabled = false;
			}
			
			if (ary.indexOf(quality) == -1) quality = ary[0];
			qualityRight = null
			_quality_array = ary;
		}
		
		public function get qualityRight():Object
		{
			return _quality_right;
		}
		
		public function set qualityRight(obj:Object):void
		{
			if (Utils.equalObject(_quality_right, obj)) return;
			_quality_right = obj;
			
			if (!_quality_array) return;
			
			for (var i:int; i != _quality_array.length; i++)
			{
				if (obj&&_quality_array[i] in obj)
				{
					quality_btns[_quality_array[i]].vip = true;
					extend_btns[_quality_array[i]].vip = true;
				}
				else {
					quality_btns[_quality_array[i]].vip = false;
					extend_btns[_quality_array[i]].vip = false;
				}
			}
		}
		
		// Internal..
		//
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			//labelFormat = FontAsset(_assetsManager.getAsset("SongTi")).format;
			
			if (!claritys) claritys = String(configuration.claritys).split(",");
			
			btn_len = claritys.length;
			if (   configuration 
				&& configuration.extendarea.length() > 0 
				&& btn_len > 1
				)
			{
				initExtendArea();
			}
			
			quality_btns = { };
			for (var i:int = 0; i != btn_len; i++)
			{
				var _label:String = claritys[i];
				var config:XMLList = configuration.asset.(hasOwnProperty("@state"));
				var btn:QualityButton 
					= new QualityButton
						( _label
						, _assetsManager.getDisplayObject(config.(@state == Keyword.NORMAL).@id)
						, _assetsManager.getDisplayObject(config.(@state == Keyword.FOCUSED).@id)
						, _assetsManager.getDisplayObject(config.(@state == Keyword.PRESSED).@id)
						, _assetsManager.getDisplayObject(config.(@state == Keyword.DISABLED).@id)
						, uint(config.(@state == Keyword.NORMAL).@fontColor)
						, uint(config.(@state == Keyword.FOCUSED).@fontColor)
						, uint(config.(@state == Keyword.PRESSED).@fontColor)
						, uint(config.(@state == Keyword.DISABLED).@fontColor)
						);
					btn.id = setMap[_label];
					
					if (btn.id == "1080p")
					{
						btn.textField.defaultTextFormat = new TextFormat("Arial", 11);
					}
					else {
						btn.textField.defaultTextFormat = new TextFormat("Verdana", 12);
					}
					btn.textField.y = 5;
					btn.textField.width = this.width;
					quality_btns[btn.id] = btn;
					btn.visible = false;
					if (_quality_right && _quality_right[btn.id] == "vip") btn.vip = true;
					else btn.vip = false;
				addChild(btn);
			}
			
			if (_quality)
			{
				quality = _quality;
				enabled = true;
			}
			
		}
		
		private function initExtendArea():void
		{
			if (extendArea)
			{
				if(this.contains(extendArea)) this.removeChild(extendArea);
				extendArea = null;
			}
			
			extendArea = new LayoutSprite();
			extendArea.style = configuration.extendarea.@style;
			addChild(extendArea);
			
			var _h:Number = ((extendarea_btn_height + extendarea_btn_interval) * btn_len);
			rectangle = new Rectangle(0, -10, this.width, _h +this.height);
			
			tween = new Tween(extendArea);
			
			extend_btns = { };
			for (var i:int = 0; i != btn_len; i++)
			{
				var _label:String = claritys[i];
				
				var config:XMLList = configuration.extendarea.asset.(hasOwnProperty("@state"));
				var btn:ToggleQualityExtendAreaButton 
					= new ToggleQualityExtendAreaButton
						( _label
						, _assetsManager.getDisplayObject(config.(@state == Keyword.NORMAL).@id)
						, _assetsManager.getDisplayObject(config.(@state == Keyword.FOCUSED).@id)
						, _assetsManager.getDisplayObject(config.(@state == Keyword.PRESSED).@id)
						, _assetsManager.getDisplayObject(config.(@state == Keyword.DISABLED).@id)
						, uint(config.(@state == Keyword.NORMAL).@fontColor)
						, uint(config.(@state == Keyword.FOCUSED).@fontColor)
						, uint(config.(@state == Keyword.PRESSED).@fontColor)
						, uint(config.(@state == Keyword.DISABLED).@fontColor)
						);
					btn.id = setMap[_label];
					btn.style = "y:" +(_h - (extendarea_btn_height * (i + 1)) - (extendarea_btn_interval * i))+";";
					btn.textField.y = 3;
					btn.textField.width = this.width;
					btn.enabled = true;
					if(btn.id == quality) btn.cur = true;
					extend_btns[btn.id] = btn;
					
					if (_quality_right && _quality_right[btn.id] == "vip") btn.vip = true;
					else btn.vip = false;
				extendArea.addChild(btn);
				
				btn.addEventListener(MouseEvent.MOUSE_UP, btnUpHandler);
			}
			
			extendArea.style = "height:" +_h +"; y:"+(-_h-2)+";";
		}
		
		private function btnUpHandler(evt:MouseEvent):void
		{
			var btn:ToggleQualityExtendAreaButton = evt.target as ToggleQualityExtendAreaButton;
			
			setCur(btn.id);
			setQuality(btn.id);
			
			dispatch(btn.id);
		}
		
		
		private function dispatch(quality:String):void
		{
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.CHANGE_QUALITY, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:quality , name:getMap[quality], action:MouseEvent.MOUSE_UP}}
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
		
		private function setCur(value:String):void
		{
			if (!extend_btns) return;
			var btn:ToggleQualityExtendAreaButton = extend_btns[value] as ToggleQualityExtendAreaButton;
			if (!btn) return;
			for each(var _btn:ToggleQualityExtendAreaButton in extend_btns)
			{
				if (_btn) _btn.cur = false;
			}
			btn.cur = true;
		}
		
		private function setQualityBtnsEnabled(b:Boolean):void
		{
			for each(var btn:QualityButton in quality_btns)
			{
				if (btn) btn.enabled = b;
			}
		}
		
		private function setQuality(value:String):void
		{
			if (!quality_btns) return;
			var btn:QualityButton = quality_btns[value] as QualityButton;
			
			if (!btn) return;
			for each(var _btn:QualityButton in quality_btns)
			{
				if (_btn) _btn.visible = false;
			}
			btn.visible = true;
		}
		
		override protected function processEnabledChange():void
		{
			if (enabled && btn_len > 1)
			{
				this.mouseChildren = true;
				
				if (extendArea) addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				if (extendArea) addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				if (extendArea) addEventListener(MouseEvent.MOUSE_DOWN, onMouseOver);
				if (stage) stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			}
			else {
				this.mouseChildren = false;
				
				if (extendArea) removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				if (extendArea) removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				if (extendArea) removeEventListener(MouseEvent.MOUSE_DOWN, onMouseOver);
				if (stage) stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			}
			setQualityBtnsEnabled(enabled);
		}
		
		
		private var _quality:String;
		private var _quality_array:Array;
		private var _quality_right:Object;
		
		private var quality_btns:Object;
		private var extend_btns:Object;
		private var claritys:Array;
		private var btn_len:int;
		private var labelFormat:TextFormat;
		
		private var extendArea:LayoutSprite;
		private var rectangle:Rectangle;
		private var tween:Tween;
		
		private var extendarea_btn_height:Number = 26;
		private var extendarea_btn_interval:Number = 1;
	}

}