package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.skin.widgets.Label;
	import com.tudou.utils.Check;
	import flash.text.TextField;
	/**
	 * VideoTitleLabel
	 */
	public class VideoTitleLabel extends Label
	{
		
		public function VideoTitleLabel()
		{
			super();
			this.color = 0xCCCCCC;
			defaultText = "";
			this.font = "Arial";
			this.size = 12;
			
			_title = "";
		}
		
		private function updateTitle(t:String):void
		{
			
			var ttl:String;
			
			//检查宽度 截取字符追加..
			ttl = Check.View(t, this.width);
			
			this.text = ttl;
		}
		
		override public function get title():String
		{
			return _title;
		}
		
		override public function set title(t:String):void
		{
			_title = t;
			
			updateTitle(_title);
		}
		
		override protected function reSetWidth():void
		{
			updateTitle(_title);
		}
		
	}

}