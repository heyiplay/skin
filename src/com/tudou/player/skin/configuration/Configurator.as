package com.tudou.player.skin.configuration 
{
	import com.tudou.player.skin.themes.ElementsProvider;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * 播放器皮肤配置器
	 * 加载解析配置文件,将皮肤元素添加到元素池中
	 * 
	 * @author 8088
	 */
	public class Configurator extends EventDispatcher
	{
		
		public function Configurator(configFilePath:String=null) 
		{
			if(configFilePath) _config_file_path = configFilePath;
			elements_provider = ElementsProvider.getInstance();
		}
		
		public function initialization():void
		{
			var loader:XMLFileLoader = new XMLFileLoader();
			loader.addEventListener(Event.COMPLETE, loadConfiguration);
			loader.load(_config_file_path);
			
			function loadConfiguration(event:Event):void
			{
				parseConfig(loader.xml);
			}
		}
		
		public function parseConfig(xml:XML):void
		{
			configuration = xml;
			elements_provider.assetsManager.addConfigurationAssets(xml..asset);
			elements_provider.widgetsManager.addConfigurationWidgets(xml..widget);
			
			//配置器初始化完成
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get data():XML
		{
			return configuration;
		}
		
		private var configuration:XML;
		
		private var _config_file_path:String;
		
		private var elements_provider:ElementsProvider;
	}

}