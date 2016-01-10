package com.tudou.player.skin.configuration 
{
	import __AS3__.vec.Vector;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	/**
	 * 用于动态编译，一期暂不使用
	 * @author 8088
	 */
	public class DynamicStatement extends EventDispatcher
	{
		
		public function DynamicStatement() 
		{
		}
		private var classCount:int = 0;
		private var completionCount:int = -1;
		private var classes:Vector.<String>;
	}

}