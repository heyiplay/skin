package com.tudou.player.interfaces
{
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	
	/**
	 * 媒体播放器模块接口
	 */
	public interface IMediaPlayerModule extends IEventDispatcher
	{
		function onNetStatus(evt:NetStatusEvent):void;
	}
	
}