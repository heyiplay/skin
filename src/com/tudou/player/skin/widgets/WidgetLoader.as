package com.tudou.player.skin.widgets
{
	import com.tudou.player.skin.MediaPlayerSkin;
	import com.tudou.utils.Debug;
	import com.tudou.net.SWFLoader;
	import flash.utils.getDefinitionByName;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	[Event(name = "complete", type = "flash.events.Event")]
	
	public class WidgetLoader extends EventDispatcher
	{
		public function load(resource:WidgetResource):void
		{
			this.resource = resource;
			
			if (resource.local == false)
			{
				if (resource.load == true)
				{
					if (resource.url.indexOf(".swz") != -1)
					{
						var swzLoader:SWFLoader = new SWFLoader();
						swzLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
						swzLoader.addEventListener(Event.COMPLETE, onLoaderComplete);
						swzLoader.load(resource.url);
					}
					else {
						var loader:Loader = new Loader();
						var lc:LoaderContext = new LoaderContext();
						var this_domain:String = new LocalConnection().domain;
						lc.checkPolicyFile = false;
						lc.applicationDomain = ApplicationDomain.currentDomain;
						if (this_domain != "localhost")
						{
							lc.securityDomain = SecurityDomain.currentDomain;
						}
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
						loader.load(new URLRequest(resource.url), lc);
					}
				}
				else {
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			else{
				_widget = constructLocalWidget();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function get widget():Widget
		{
			return _widget; 
		}
		
		protected var resource:WidgetResource;
		private var _widget:Widget;
		
		protected function onLoaderError(evt:IOErrorEvent):void
		{
			Debug.log("警告:从"+ resource.url+" 加载 widget 失败，ID:"+ resource.id, 0xFFBB33);
			//dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function onLoaderComplete(evt:Event):void
		{
			var loaderInfo:LoaderInfo;
			if (evt.target as LoaderInfo)
			{
				loaderInfo = evt.target as LoaderInfo;
			}
			else {
				var loader:SWFLoader = evt.target as SWFLoader;
				loaderInfo = loader.contentLoaderInfo;
			}
			
			_widget = constructLoadedWidget(loaderInfo);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function constructLoadedWidget(loaderInfo:LoaderInfo):Widget
		{
			var widget:Widget;
			var type:Class;
			
			if (resource is WidgetResource){
				type = loaderInfo.applicationDomain.getDefinition(resource.symbol) as Class;
				widget = new type() as Widget;
				if(widget) widget.configuration = resource.config;
			}
			
			return widget;
		}
		
		protected function constructLocalWidget():Widget
		{
			var id:String = resource.id; 
			
			var symbol:Class;
			
			if (symbol == null)
			{
				try 
				{
					symbol = getDefinitionByName(resource.url || "") as Class;
				}
				catch (error:Error) {
					
					if (String(resource.url).length>1)
					{
						Debug.log("警告：未定义：" + resource.url, 0xFFBB33);
					}
					symbol = Widget;
					
				}
			}
			var widget:Widget = new symbol();
			
			// 配置widget
			widget.configuration = resource.config;
			
			return widget;
		}
	}
}