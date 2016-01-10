package com.tudou.player.skin.net 
{
	import com.adobe.serialization.json.JSON;
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
	 * JSON 文件加载器
	 * 
	 * @author 8088
	 */
	public class JSONFileLoader extends EventDispatcher
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
		
		public function get json():*
		{
			var json:* = null;
			try
			{
				json = loader 
					? loader.data != null
						? JSON.decode(loader.data)
						: null
					: null;
			} 
			catch (error:Error) {
				throw new Error("JSON文件格式错误！" + url);
			}
			return json;
		}
		
		// Internals
		//
		
		private function completionSignalingHandler(event:Event):void
		{			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function errorHandler(event:Event):void
		{			
			dispatchEvent(event.clone());
		}
		
		private var loader:URLLoader;
		private var url:String;
		
	}

}