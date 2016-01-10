package com.tudou.player.skin.widgets 
{
	import com.tudou.player.skin.configuration.WidgetsParser;
	
	import __AS3__.vec.Vector;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * WidgetsManager
	 */
	public class WidgetsManager extends EventDispatcher
	{
		
		public function WidgetsManager() 
		{
			top = new Vector.<String>();
			bottom = new Vector.<String>();
			left = new Vector.<String>();
			right = new Vector.<String>();
			middle = new Vector.<String>();
			
			loaders = new Dictionary();
			resourceByLoader = new Dictionary();
		}
		
		public function addConfigurationWidgets(widgets:XMLList):void
		{
			var parser:WidgetsParser = new WidgetsParser();
			parser.parse(widgets, this);
			
		}
		
		public function addWidget(resource:WidgetResource, loader:WidgetLoader, area:String=null):void
		{
			var currentLoader:WidgetLoader = getLoader(resource.id);
			if (currentLoader != null)
			{
				return;
			}
			else{
				widgetCount++;
				
				loaders[resource] = loader;
				resourceByLoader[loader] = resource;
			}
			
			var s:String
			if (area)
			{
				s = area;
			}
			else {
				s = resource.id.slice(0, resource.id.indexOf(".")).toLowerCase();
			}
			
			switch(s) {
				case "toparea":
					top.push(resource.id);
					break;
				case "bottomarea":
					bottom.push(resource.id);
					break;
				case "leftarea":
					left.push(resource.id);
					break;
				case "rightarea":
					right.push(resource.id);
					break;
				case "middlearea":
					middle.push(resource.id);
					break;
			}
		}
		
		public function getResource(loader:WidgetLoader):WidgetResource
		{
			return resourceByLoader[loader];
		}
		
		public function getLoader(id:String):WidgetLoader
		{
			var result:WidgetLoader;
			
			for each (var resource:WidgetResource in resourceByLoader)
			{
				if (resource.id == id)
				{
					result = loaders[resource];
					break;
				}
			}
			
			return result;
		}
		
		public function getWidget(id:String):Widget
		{
			var loader:WidgetLoader = getLoader(id);
			return loader ? loader.widget : null;
		}
		
		public function load():void
		{
			completionCount = widgetCount;
			for each (var loader:WidgetLoader in loaders)
			{
				loader.addEventListener(Event.COMPLETE, onWidgetLoaderComplete);
				loader.load(resourceByLoader[loader]);
			}
		}
		
		// Internals
		//
		
		private var loaders:Dictionary;
		private var resourceByLoader:Dictionary;
		
		private var widgetCount:int = 0;
		private var _completionCount:int = -1;
		
		private function set completionCount(value:int):void
		{
			if (_completionCount != value)
			{
				_completionCount = value;
				if (_completionCount == 0)
				{
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
		private function get completionCount():int
		{
			return _completionCount;
		}
		
		private function onWidgetLoaderComplete(evt:Event):void
		{
			var loader:WidgetLoader = evt.target as WidgetLoader;
			var resource:WidgetResource = resourceByLoader[evt.target];
			
			completionCount--;
		}
		
		public var top:Vector.<String>;
		public var bottom:Vector.<String>;
		public var left:Vector.<String>;
		public var right:Vector.<String>;
		public var middle:Vector.<String>;
		
		//OVER
	}

}