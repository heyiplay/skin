package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.skin.widgets.Label;
	import com.tudou.player.skin.utils.TimeUtil;
	import flash.text.TextField;
	/**
	 * VideoTimeLabel
	 */
	public class VideoTimeLabel extends Label
	{
		
		public function VideoTimeLabel()
		{
			super();
			
			//this.autoSize = "center";
			this.color = 0xCCCCCC;
			defaultText = _cur + " / " + _total;
			this.font = "Arial";
			this.size = 14;
			
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
				this.htmlText = "<p>"
							+	"<font face='Arial' color='"+_cur_color+"' size='14'>" + _cur + "</font>"
							+	"<font face='Arial' color='"+_total_color+"' size='14'> / " + _total + "</font>"
							+"</p>";
			}
			else {
				this.htmlText = "<p>"
							+	"<font face='Arial' color='"+_disabled_color+"' size='14'>" + _cur + "</font>"
							+	"<font face='Arial' color='"+_disabled_color+"' size='14'> / " + _total + "</font>"
							+"</p>";
			}
			
		}
		
		override protected function processEnabledChange():void
		{
			super.processEnabledChange();
			updateTime();
		}
		
		private var _total_time:Number = 0;
		private var _cur_time:Number = 0;
		private var _total:String = "00:00";
		private var _cur:String = "00:00";
		
		private var _disabled_color:String = "#CCCCCC";
		private var _total_color:String = "#444444";
		private var _cur_color:String = "#444444";
	}

}