package com.tudou.player.skin.configuration 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="io_error", type="flash.events.IOErrorEvent")]
	[Event(name="security_error", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * XML 文件加载器
	 * 
	 * @author 8088
	 */
	public class XMLFileLoader extends EventDispatcher
	{
		
		public function load(url:String):void
		{
			this.url = url;
			
			loader = new URLLoader();
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, completionSignalingHandler);
			loader.load(new URLRequest(url));
		}	
		
		public function get xml():XML
		{
			var xml:XML = null;
			try
			{
				xml = loader 
					? loader.data != null
						? new XML(loader.data)
						: null
					: null;
			} 
			catch (error:Error) {
				throw new Error("XML文件标签错误！" + url);
			}
			return xml;
		}
		
		// Internals
		//
		
		private function completionSignalingHandler(event:Event):void
		{			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function errorHandler(event:Event):void
		{		
			//现在没在用，先注释掉；
			//dispatchEvent(event.clone());
		}
		
		private var loader:URLLoader;
		private var url:String;
		
	}

}