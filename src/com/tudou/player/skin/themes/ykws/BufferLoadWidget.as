package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.widgets.Label;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author 8088
	 */
	public class BufferLoadWidget extends Widget
	{
		
		public function BufferLoadWidget() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			this.mouseEnabled = false;
			this.enabled = false;
			loading = _assetsManager.getDisplayObject("BufferLoading") as MovieClip;
			addChild(loading);
			
			loading.height = loading.width = 95;
			this.style = "position:relative; " + "width:" + loading.width + ";height:" + loading.height + "; left:50%; top:50%; visible:false;"
			msg = new Label();
			msg.style = "width:" + (loading.width - 4) + "; height:" + Math.floor(loading.width/3) + "; x:4; y:" + Math.floor(loading.width/19 * 11) + ";";
			msg.multiline = false;
			msg.color = 0xffffff;
			msg.align = "center";
			msg.font = "微软雅黑,Microsoft Yahei,simsun,_sans";
			msg.leading = 1;
			msg.size = 16;
			msg.text = "加载中..."
			addChild(msg);
		}
		private var msg:Label;
		private var loading:MovieClip;
	}

}