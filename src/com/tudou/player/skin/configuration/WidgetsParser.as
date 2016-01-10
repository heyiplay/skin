package com.tudou.player.skin.configuration 
{
	import com.tudou.utils.Debug;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.widgets.WidgetsManager;
	import com.tudou.player.skin.widgets.WidgetResource;
	import com.tudou.player.skin.widgets.WidgetLoader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flash.errors.IllegalOperationError;
	
	public class WidgetsParser 
	{
		public function parse(widgetsList:XMLList, widgetsManager:WidgetsManager):void
		{
			staticAddWidget(widgetsList, widgetsManager);
			
		}
		
		
		// Internals
		//
		
		private function staticAddWidget(widgetsList:XMLList, widgetsManager:WidgetsManager):void
		{
			
			for each (var config:XML in widgetsList)
			{
				var loader:WidgetLoader;
				var resource:WidgetResource;
				loader = new WidgetLoader();
				resource = new WidgetResource(config);
				if (loader && resource)
				{
					var area:String = config.parent().name().toString();
					widgetsManager.addWidget(resource, loader, area);
				}
				else{
					throw new IllegalOperationError("无法找到widget类", config.@url);
				}
			}
		}
		
		
	}

}