package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.skin.widgets.Label;
	import com.tudou.player.skin.utils.TimeUtil;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * VideoTimeLabel
	 */
	public class VideoTimeLabel extends Label
	{
		
		public function VideoTimeLabel()
		{
			super();
		}
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			if (!config) config = configuration.videotime[0];
			if (config)
			{
				_fontsize = parseInt(config.@fontsize);
				_fontname = String(config.@fontname);
			
				_disabled_color = uint(config.@disabledfontcolor);
				_cur_color = uint(config.@normalfontcolor);
			}
			this.color = _disabled_color;
			defaultText = _cur + " / " + _total;
			this.font = _fontname;
			this.size = _fontsize;
			
			updateTime();
		}
		public function set totalTime(t:Number):void
		{
			_total_time = t;
			
			_total = TimeUtil.formatAsTimeCode(_total_time);
			
			updateTime();
		}
		
		public function set curTime(t:Number):void
		{
			_cur_time = t;
			
			_cur = TimeUtil.formatAsTimeCode(_cur_time);
			
			updateTime();
		}
		
		private function updateTime():void
		{
			if (enabled)
			{
				var str:String = "#" + _cur_color.toString(16);
				this.htmlText = "<p>"
							+	"<font face='" + _fontname + "' color='" + str + "' size='" + _fontsize + "'>" + _cur + "</font>"
							+	"<font face='" + _fontname + "' color='" + str + "' size='" + _fontsize + "'> / " + _total + "</font>"
							+ "</p>";
			}
			else {
				var str2:String = "#" + _disabled_color.toString(16);
				this.htmlText = "<p>"
							+	"<font face='" + _fontname + "' color='" + str2 + "' size='" + _fontsize + "'>" + _cur + "</font>"
							+	"<font face='" + _fontname + "' color='" + str2 + "' size='" + _fontsize + "'> / " + _total + "</font>"
							+ "</p>";
			}
		}
		
		override protected function processEnabledChange():void
		{
			super.processEnabledChange();
			updateTime();
		}
		private var config:XML;
		
		private var _total_time:Number = 0;
		private var _cur_time:Number = 0;
		private var _total:String = "00:00";
		private var _cur:String = "00:00";
		
		private var _fontname:String = "Arial";
		private var _fontsize:int = 11;
		private var _disabled_color:uint = 0x333333;
		private var _cur_color:uint = 0x999999;
	}

}