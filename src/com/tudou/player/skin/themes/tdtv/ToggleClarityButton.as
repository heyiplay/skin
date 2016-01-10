package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.events.SchedulerEvent;
	import com.tudou.events.TweenEvent;
	import com.tudou.layout.LayoutSprite;
	import com.tudou.player.events.NetStatusCommandCode;
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
	 * ToggleClarityButton
	 * 
	 * @author 8088
	 */
	public class ToggleClarityButton extends Widget
	{
		
		private var setMap:Object = { "320P":"320p", "480P":"480p", "720P":"720p", "1080P":"1080p" };
		private var getMap:Object = { "320p":"320P", "480p":"480P", "720p":"720P", "1080p":"1080P" };
		
		public function ToggleClarityButton() 
		{
			super();
		}
		
		public function get clarity():String
		{
			return _clarity;
		}
		
		public function set clarity(value:String):void
		{
			if (_clarity == value) return;
			
			setCur(value);
			
			setClarity(value);
			
			_clarity = value;
		}
		
		public function get clarityArray():Array
		{
			return _clarity_array;
		}
		
		public function set clarityArray(ary:Array):void
		{
			if (ArrayUtil.equals(_clarity_array, ary)) return;
			
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
			
			if (ary.indexOf(clarity) == -1) clarity = ary[0];
			clarityRight = null
			_clarity_array = ary;
		}
		
		public function get clarityRight():Object
		{
			return _clarity_right;
		}
		
		public function set clarityRight(obj:Object):void
		{
			if (Utils.equalObject(_clarity_right, obj)) return;
			_clarity_right = obj;
			
			if (!_clarity_array) return;
			
			for (var i:int; i != _clarity_array.length; i++)
			{
				if (obj&&_clarity_array[i] in obj)
				{
					clarity_btns[_clarity_array[i]].vip = true;
					extend_btns[_clarity_array[i]].vip = true;
				}
				else {
					clarity_btns[_clarity_array[i]].vip = false;
					extend_btns[_clarity_array[i]].vip = false;
				}
			}
		}

		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			labelFormat = FontAsset(_assetsManager.getAsset("RobotoBoldCondensed")).format;
			labelFormat.size = 10;
			
			if(!claritys) claritys = String(configuration.claritys).split(",");
			btn_len = claritys.length;
			
			if (   configuration 
				&& configuration.extendarea.length() > 0 
				&& btn_len > 1
				)
			{
				initExtendArea();
			}
			var config:XMLList = configuration.asset.(hasOwnProperty("@state"));
			clarity_btns = { };
			for (var i:int = 0; i != btn_len; i++)
			{
				var _label:String = claritys[i];
				
				var btn:ClarityButton 
					= new ClarityButton
						( _assetsManager.getDisplayObject(config.(@state == Keyword.NORMAL).@id)
						, _assetsManager.getDisplayObject(config.(@state == Keyword.FOCUSED).@id)
						, _assetsManager.getDisplayObject(config.(@state == Keyword.PRESSED).@id)
						, _assetsManager.getDisplayObject(config.(@state == Keyword.DISABLED).@id)
						);
				btn.id = setMap[_label];
				btn.format = labelFormat;
				btn.label = _label;
				
				clarity_btns[btn.id] = btn;
				btn.visible = false;
				if (_clarity_right && _clarity_right[btn.id] == "vip") btn.vip = true;
				else btn.vip = false;
				addChild(btn);
			}
			
			if (_clarity)
			{
				clarity = _clarity;
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
			var config:XMLList = configuration.extendarea.asset.(hasOwnProperty("@state"));
			for (var i:int = 0; i != btn_len; i++)
			{
				var _label:String = claritys[i];
				
				var btn:ToggleClarityExtendAreaButton = new ToggleClarityExtendAreaButton
					( _assetsManager.getDisplayObject(config.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(config.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(config.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(config.(@state == Keyword.DISABLED).@id)
					);
				btn.id = setMap[_label];
				btn.label = _label;
				btn.format = labelFormat;
				btn.y = (_h - (extendarea_btn_height * (i + 1)) - (extendarea_btn_interval * i));
				
				btn.enabled = true;
				if(btn.id == clarity) btn.cur = true;
					extend_btns[btn.id] = btn;
					
					if (_clarity_right && _clarity_right[btn.id] == "vip") btn.vip = true;
					else btn.vip = false;
				extendArea.addChild(btn);
				btn.vip = false;
				btn.addEventListener(MouseEvent.MOUSE_UP, btnUpHandler);
			}
			extendArea.style = "height:" +_h +";y:"+(-_h-3)+";";
		}
		
		private function btnUpHandler(evt:MouseEvent):void
		{
			var btn:ToggleClarityExtendAreaButton = evt.target as ToggleClarityExtendAreaButton;
			
			setCur(btn.id);
			setClarity(btn.id);
			
			dispatch(btn.id);
		}
		
		
		private function dispatch(c:String):void
		{
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_QUALITY, level:"command", data:{ id:this.id, value:c, action:MouseEvent.MOUSE_UP}}
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
		
		private function setCur(id:String):void
		{
			if (!extend_btns) return;
			var btn:ToggleClarityExtendAreaButton = extend_btns[id] as ToggleClarityExtendAreaButton;
			if (!btn) return;
			for each(var _btn:ToggleClarityExtendAreaButton in extend_btns)
			{
				if (_btn) _btn.cur = false;
			}
			btn.cur = true;
		}
		
		private function setClarityBtnsEnabled(b:Boolean):void
		{
			for each(var btn:ClarityButton in clarity_btns)
			{
				if (btn) btn.enabled = b;
			}
		}
		
		private function setClarity(id:String):void
		{
			if (!clarity_btns) return;
			var btn:ClarityButton = clarity_btns[id] as ClarityButton;
			
			if (!btn) return;
			for each(var _btn:ClarityButton in clarity_btns)
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
			setClarityBtnsEnabled(enabled);
		}
		
		
		private var _clarity:String;
		private var _clarity_array:Array;
		private var _clarity_right:Object;
		private var clarity_btns:Object;
		private var extend_btns:Object;
		private var claritys:Array;
		private var btn_len:int;
		private var labelFormat:TextFormat;
		
		private var extendArea:LayoutSprite;
		private var rectangle:Rectangle;
		private var tween:Tween;
		private var extendarea_btn_height:Number = 20;
		private var extendarea_btn_interval:Number = 2;
	}

}