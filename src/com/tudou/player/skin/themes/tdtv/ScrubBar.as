package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.events.TweenEvent;
	import com.tudou.net.JSONFileLoader;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.events.ScrubberEvent;
	import com.tudou.utils.Check;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.widgets.Slider;
	import com.tudou.player.skin.widgets.Label;
	import com.tudou.player.skin.widgets.Hint;
	import com.tudou.layout.LayoutSprite;
	import com.tudou.player.skin.utils.TimeUtil;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.utils.Debug;
	import com.tudou.utils.Tween;
	import flash.display.StageDisplayState;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	/**
	 * ScrubBar
	 */
	public class ScrubBar extends Widget
	{
		
		public function ScrubBar()
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			info = _widgetsManager.getWidget("InformationWidget") as Widget;
			if (info) {
				infoTween = new Tween(info);
				infoTween.addEventListener(TweenEvent.END, infoTweenEndHandler);
			}
			
			backdrop = _assetsManager.getDisplayObject("ScrubBarBackground") as Sprite;
			backdrop.mouseChildren = false;
			var grid:Rectangle = new Rectangle(1, 1, 3, 1);
			backdrop.scale9Grid = grid;
			backdrop.width = this.width;
			backdrop.height = 6;
			addChild(backdrop);
			backdropTween = new Tween(backdrop);
			
			loaded = _assetsManager.getDisplayObject("ScrubBarLoaded") as Sprite;
			loaded.x = 1;
			loaded.y = 1;
			loaded.visible = false;
			addChild(loaded);
			loadedTween = new Tween(loaded);
			
			glow = _assetsManager.getDisplayObject("ScrubBarPlayedGlow") as Bitmap;
			glow.x = loaded.x;
			glow.y = 1;
			glow.visible = false;
			glow.alpha = 0;
			addChild(glow);
			glowTween = new Tween(glow);
			
			played = _assetsManager.getDisplayObject("ScrubBarPlayed") as Sprite;
			played.x = loaded.x;
			addChild(played);
			playedTween = new Tween(played);
			
			var cofing:XMLList = configuration.button.(@id == "ScrubBarSlider").asset.(hasOwnProperty("@state"));
			slider = new Slider
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			slider.x = played.x + slider.width/2;
			slider.y = int(played.height * .5);
			slider_w = slider.width;
			slider_h = slider.height;
			
			sliderStart =  slider.x;
			sliderEnd = this.width - slider.width * .5 -1;
			
			slider.origin = sliderStart;
			slider.rangeY = 0.0;
			slider.rangeX = sliderEnd - sliderStart;
			addChild(slider);
			sliderTween = new Tween(slider);
			
			rectangle = new Rectangle(0, -80, this.width, 50);
			
			slider.addEventListener(ScrubberEvent.SCRUB_START, sliderStartHandler);
			slider.addEventListener(ScrubberEvent.SCRUB_UPDATE, sliderUpdateHandler);
			slider.addEventListener(ScrubberEvent.SCRUB_END, sliderEndHandler);
			
			hintY = -1;
			hintHover = true;
			enabled = true;
		}
		
		private function sliderStartHandler(evt:ScrubberEvent=null):void
		{
			if (_seeking) return;
			_seeking = true;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:SkinNetStatusEventCode.SCRUBBAR_SLIDER_START, level:"status"}
				)
			);
		}
		
		private function sliderUpdateHandler(evt:ScrubberEvent = null):void
		{
			var newPlayed:Number = this.mouseX / this.width;
			seekToX(newPlayed);
		}
		
		private function sliderEndHandler(evt:ScrubberEvent = null):void
		{
			var newPlayed:Number = this.mouseX / this.width;
			seekToX(newPlayed);
			//..
			dispatch(Number((_total_time*newPlayed).toFixed(3)));
			_seeking = false;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:SkinNetStatusEventCode.SCRUBBAR_SLIDER_END, level:"status"}
				)
			);
		}
		
		private function dispatch(_time:Number):void
		{
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SEEK, level:"command", data:{ id:this.id, time:_time }}
				)
			);
			
		}
		
		private function scrubMoveHandler(evt:MouseEvent):void
		{
			var rate:Number = (this.mouseX-1) / (this.width-2);
			if (rate < 0.001) rate = 0;
			if (rate > 0.999) rate = 1;
			var dot:Dot = evt.target as Dot;
			if(!dot) Hint.text = TimeUtil.formatAsTimeCode(_total_time * rate);
		}
		
		private function scrubDownHandler(evt:MouseEvent):void
		{
			if (evt.target == slider) return;
			var newPlayed:Number;
			
			newPlayed = (mouseX-1) / (this.width - 2);
			
			seekToX(newPlayed);
			
			if (!_seeking)
			{
				slider.onMouseDown();
				sliderStartHandler();
			}
		}
		
		private function seekToX(relativePositition:Number):void
		{
			setPlayedWidth(relativePositition);
			
			if(!_seeking) setSliderX();
		}
		
		private function setSliderX():void
		{
			if (!played) return;
			
			if (slider) slider.x = countSliderX();
		}
		
		private var slider_w:Number;
		private var slider_h:Number;
		private function countSliderX():Number
		{
			var slider_x:Number;
			if (played.width <= sliderStart) slider_x = sliderStart;
			else if (played.width >= sliderEnd) slider_x = sliderEnd;
			else slider_x = played.x + played.width;
			return slider_x;
		}
		
		private function setPlayedWidth(num:Number):void
		{
			_played_rate = num;
			if (_played_rate > 1) _played_rate = 1;
			if (_played_rate < 0) _played_rate = 0;
			if (played) played.width =  (this.width - 2) * _played_rate;
			if (glow) 
			{
				if (played.width >= 20&&(this.width - played.width) > 4) {
					glow.visible = true;
					glow.x = played.width - 20;
				}
				else {
					glow.visible = false;
					glow.x = 0;
				}
			}
		}
		
		private function setLoadedWidth(num:Number):void
		{
			_loaded_rate = num;
			if (_loaded_rate > 1) _loaded_rate = 1;
			if (_loaded_rate < 0) _loaded_rate = 0;
			if (loaded) 
			{
				loaded.visible = true;
				loaded.width =  (this.width - 2) * _loaded_rate;
			}
		}
		
		private function closeTween():void
		{
			backdropTween.cancel();
			loadedTween.cancel();
			playedTween.cancel();
			dotsTween.cancel();
			sliderTween.cancel();
			glowTween.cancel();
			if(info&&infoTween) infoTween.cancel();
		}
		
		private function tweenToMin():void
		{
			backdropTween.easeOut().from( { y:backdrop.y, height:backdrop.height } ).to( { y:3, height:3 }, 300);
			loadedTween.easeOut().from( { y:loaded.y, height:loaded.height } ).to( { y:4, height:2 }, 300);
			playedTween.easeOut().from( { y:played.y, height:played.height } ).to( { y:4, height:2 }, 300);
			sliderTween.easeOut().from( { y:slider.y, scaleX:slider.scaleX, scaleY:slider.scaleY } ).to( { y:5, scaleX:0, scaleY:0 }, 300);
			glowTween.easeOut().from( { alpha:0 } ).to( { alpha:1 }, 300);
			if(infoTween) infoTween.easeOut().from( { y:info.y } ).to( { y:-24 }, 300);
		}
		
		private function tweenToMax():void
		{
			backdropTween.from( { y:backdrop.y, height:backdrop.height } ).to( { y:0, height:6 }, 200);
			loadedTween.from( { y:loaded.y, height:loaded.height } ).to( { y:1, height:5 }, 200);
			playedTween.from( { y:played.y, height:played.height } ).to( { y:0, height:6 }, 200);
			sliderTween.from( { y:slider.y, scaleX:slider.scaleX, scaleY:slider.scaleY } ).to( { y:3, scaleX:1, scaleY:1 }, 200);
			glowTween.easeOut().from( { alpha:1 } ).to( { alpha:0 }, 200);
			if(infoTween) infoTween.easeOut().from( { y:info.y } ).to( { y:-27 }, 200);
		}
		
		private function infoTweenEndHandler(evt:TweenEvent):void
		{
			info.css.map.put("y", String(info.y));
			info.css.y = info.y;
		}
		
		private function listenMouse():void
		{
			if (stage) 
			{
				mouseMove(null);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				stage.addEventListener(Event.MOUSE_LEAVE, mouseLeve);
			}
		}
		
		private function removeListenMouse():void
		{
			if (stage) 
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeve);
				destroyTimer();
			}
		}
		
		private function mouseLeve(evt:Event):void
		{
			if (_seeking) return;
			destroyTimer();
			mini = true;
		}
		
		private function mouseMove(evt:Event):void
		{
			var point:Point = new Point(this.mouseX, this.mouseY);
			var mouse_away:Boolean = Check.Out(point, rectangle);
			
			if (mouse_away)
			{
				startTimer();
			}
			else {
				mini = false;
				destroyTimer();
			}
		}
		
		private var toMiniTimer:Timer;
		private function startTimer():void
		{
			if (toMiniTimer)
			{
				toMiniTimer.reset();
				toMiniTimer.start();
			}
			else {
				toMiniTimer = new Timer(2000, 1);
				toMiniTimer.addEventListener(TimerEvent.TIMER, mouseLeve);
				toMiniTimer.start();
			}
		}
		
		private function destroyTimer():void
		{
			if (toMiniTimer) {
				toMiniTimer.stop();
				toMiniTimer.removeEventListener(TimerEvent.TIMER, mouseLeve);
				toMiniTimer = null;
			}
		}
		
		//处理看点数据
		private function loadDotsData():void
		{
			var loader:JSONFileLoader = new JSONFileLoader();
			loader.addEventListener(Event.COMPLETE, loadedHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.load(DOT_SERVICE + _drama_id);
			function loadedHandler(evt:Event):void
			{
				parseData(loader.json);
			}
		}
		
		private function errorHandler(evt:IOErrorEvent):void
		{
			Debug.log("看点数据无法载入！", Debug.RED)
		}
		
		private function parseData(json:*):void
		{
			data = json;
			
			if(_video_id) getDotsData(_video_id);
			
		}
		
		private function getDotsData(iid:String):void
		{
			for (var key:* in data)
			{
				if (data[key].iid == iid)
				{
					addDotsByData(data[key].storyPoints);
					break;
				}
			}
		}
		
		private function addDotsByData(config:*):void
		{
			if (!_total_time) return;
			for (var key:* in config)
			{
				var _time:Number = Number(config[key].time) / 1000;
				var _n:Number = _time / _total_time;
				var _t:String = TimeUtil.formatAsTimeCode(_time);
				var _i:String = config[key].content;
				addDot(_n, _t, _i);
			}
		}
		
		
		//API
		public function set playProgress(num:Number):void
		{
			if (!_seeking)
			{
				setPlayedWidth(num);
				setSliderX();
			}
		}
		
		public function set loadProgress(num:Number):void
		{
			setLoadedWidth(num);
		}
		
		public function get mini():Boolean
		{
			return _mini;
		}
		
		public function set mini(m:Boolean):void
		{
			if (dots)
			{
				var l:int = dots.numChildren;
				for (var i:int = 0; i != l; i++)
				{
					var dot:Dot = dots.getChildAt(i) as Dot;
					dot.mini = m;
				}
			}
			
			if (_mini == m) return;
			_mini = m;
			if (_mini) tweenToMin();
			else tweenToMax();
		}
		
		public function set pause(p:Boolean):void
		{
			_video_pause = p;
			if (_video_pause) 
			{
				mini = false;
				removeListenMouse();
			}
			else listenMouse();
		}
		
		override protected function processEnabledChange():void
		{
			this.mouseChildren = enabled;
			this.buttonMode = enabled;
			
			
			if (slider)
			{
				slider.visible = enabled;
				slider.enabled = enabled;
			}
			
			if (played)
			{
				played.visible = enabled;
				if (played.visible&&played.width >= 20&&(this.width - played.width) > 4) {
					glow.visible = true;
				}
				else {
					glow.visible = false;
				}
			}
			
			if (enabled)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN, scrubDownHandler);
				this.addEventListener(MouseEvent.MOUSE_MOVE, scrubMoveHandler);
				if(stage) Hint.register(this);
			}
			else {
				if(stage) Hint.unregister(this);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, scrubDownHandler);
				this.removeEventListener(MouseEvent.MOUSE_MOVE, scrubMoveHandler);
			}
		}
		
		override protected function reSetWidth():void
		{
			if(backdrop) backdrop.width = this.width;
			if (dots)
			{
				var l:int = dots.numChildren;
				for (var i:int = 0; i != l; i++)
				{
					var dot:Dot = dots.getChildAt(i) as Dot;
					dot.reSet(this.width);
				}
			}
			
			if (slider)
			{
				sliderEnd = this.width - slider_w * .5 -1;
				slider.rangeX = sliderEnd - sliderStart;
			}
			playProgress = _played_rate;
			loadProgress = _loaded_rate;
			rectangle = new Rectangle(0, -50, this.width, this.height+28);
		}
		
		public function set totalTime(t:Number):void
		{
			_total_time = t;
		}
		
		public function addDot(num:Number, time:String="00:00", info:String=""):void
		{
			if (num > 0 && num < 1)
			{
				var dot_normal:Sprite = _assetsManager.getDisplayObject("DotNormal") as Sprite;
				var dot_focused:Sprite = _assetsManager.getDisplayObject("DotFocused") as Sprite;
				var dot:Dot = new Dot(num, this.width, dot_normal, dot_focused, time, info, mini);
				dots.addChild(dot);
			}
		}
		
		public function removeDots():void
		{
			var ln:int = dots.numChildren;
			for (var i:int = 0; i != ln; i++)
			{
				dots.removeChildAt(0);
			}
		}
		
		public function reSetDots(iid:String, aid:String):void
		{
			if (iid == "" || aid == "") return;
			if (_drama_id != aid)
			{
				_drama_id = aid;
				_video_id = iid;
				
				//看点数据是以剧集为单位的，剧集ID变化，则从新请求看点数据
				loadDotsData();
				return;
			}
			
			if (_video_id != iid)
			{
				_video_id = iid;
				//视频ID变化，则重新打看点
				getDotsData(_video_id);
			}
			
		}
		
		private var backdrop:Sprite;
		private var played:Sprite;
		private var dots:Sprite;
		private var loaded:Sprite;
		private var slider:Slider;
		private var glow:Bitmap;
		private var info:Widget;
		
		private var backdropTween:Tween;
		private var playedTween:Tween;
		private var dotsTween:Tween;
		private var loadedTween:Tween;
		private var sliderTween:Tween;
		private var glowTween:Tween;
		private var infoTween:Tween;
		
		private var _seeking:Boolean;
		private var _seek_time:Number;
		private var _total_time:Number = 0;
		
		private var _played_rate:Number = 0.0;
		private var _loaded_rate:Number = 0.0;
		
		public var sliderStart:Number;
		public var sliderEnd:Number;
		private var _mini:Boolean;
		private var _video_pause:Boolean;
		private var rectangle:Rectangle;
		private var _video_id:String;
		private var _drama_id:String;
		private var data:*;
		
		private static const DOT_SERVICE:String = "http://www.tudou.com/tva/srv/alistEx.action?a=";
		
	}

}

import com.tudou.utils.Debug;
import com.tudou.utils.Global;
import com.tudou.utils.Scheduler;
import com.tudou.player.skin.widgets.Hint;
import com.tudou.utils.Tween;

import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
class Dot extends Sprite
{
	public function Dot(n:Number, w:Number, normal:DisplayObject, focused:DisplayObject, time:String = "00:00", info:String = "", mini:Boolean = false ):void
	{
		this.mouseChildren = false;
		this._n = n;
		
		this.normal = normal
		this.focused = focused
		this._t = time;
		this._i = info.replace(/[　\s\t\n\r]/g, "");
		//trace(this._i.length)
		updateFace(normal);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		
		txt = new TextField();
		txt.x = 40;
		txt.y = 4;
		txt.width = 90;
		txt.defaultTextFormat = new TextFormat("Arial", 12, 0xFFFFFF);
		txt.wordWrap = true;
		txt.text = _i;
		txt.mouseEnabled = false;
		if (txt.numLines == 1)
		{
			txt.height = 18;
			txt.width = txt.textWidth + 7;
		}
		else {
			txt.height = 38;
			if (this._i.length > 14)
			{
				txt.width = 100;
				txt.x = 33;
			}
			else {
				txt.width = 90;
				txt.x = 41;
			}
		}
		
		reSet(w);
		
		tween = new Tween(this);
		
		this._mini = mini;
		if (_mini)
		{
			
			this.y = 9;
			this.width = 2;
			this.height = 2;
		}
		else {
			this.y = 6;
			this.width = 10;
			this.height = 10;
		}
	}
	
	private function tweenToMin():void
	{
		tween.easeOut().from( { y:this.y, width:this.width, height:this.height } ).to( { y:9, width:2, height:2 }, 300);
	}
	
	private function tweenToMax():void
	{
		tween.from( { y:this.y, width:this.width, height:this.height } ).to( { y:6, width:10, height:10 }, 200);
	}
		
	private function updateFace(face:DisplayObject):void
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
	
    private function onMouseOver(evt:MouseEvent):void
    {
        updateFace(focused);
        txt.y = Hint.label.y;
        Hint.text = _t;
        var option:Object = { };
        if (_i.length > 14)
        {
            option.labelX = -4;
            option.areaWidth = 130;
        }
        else {
            option.labelX = 2;
        }
        
        Hint.insert(txt, option);
    }
    
    private function onMouseOut(evt:MouseEvent):void
    {
        updateFace(normal);
        Scheduler.setTimeout(10, function(e:Event):void { 
            var option:Object = { };
            var temp:TextField = Hint.area.getChildAt(Hint.area.numChildren-1) as TextField;
            if (temp)
            {
                if (temp.text.length > 14&&temp != txt)
                {
                    option.labelX = -4;
                    option.areaWidth = 130;
                }
                else {
                    option.labelX = 2;
                    option.areaWidth = 0;
                }
            }
            Hint.remove(txt, option);
        });
    }
	
	public function reSet(w:Number):void
	{
		this.x = int(w * _n);
	}
	
	public function get mini():Boolean
	{
		return _mini;
	}
	
	public function set mini(m:Boolean):void
	{
		if (_global.status.displayState != StageDisplayState.NORMAL)
		{
			if (_mini)
			{
				_mini = false;
				tweenToMax();
			}
			return;
		}
		if (_mini == m) return;
		_mini = m;
		if (_mini)tweenToMin();
		else tweenToMax();
	}
	
	public var hintHover:Boolean = true;
	
	private var _global:Global = Global.getInstance();
	
	private var normal:DisplayObject;
	private var focused:DisplayObject;
	private var currentFace:DisplayObject;
	private var txt:TextField;
	private var tween:Tween;
	private var _mini:Boolean;
	
	private var _c:uint = 0xFFFFFF;
	private var _a:Number = 1;
	private var _n:Number = 0;
	private var _t:String = "00:00";
	private var _i:String = "";
}