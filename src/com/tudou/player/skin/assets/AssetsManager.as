package com.tudou.player.skin.assets
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.Dictionary;
	
	import com.tudou.player.skin.configuration.AssetsParser;
	
	[Event(name="complete", type="flash.events.Event")]
	
	public class AssetsManager extends EventDispatcher
	{
		// API
		//
		
		public function AssetsManager()
		{
			loaders = new Dictionary();
			resourceByLoader = new Dictionary();
		}
		
		public function addConfigurationAssets(assets:XMLList):void
		{
			var parser:AssetsParser = new AssetsParser();
			parser.parse(assets, this);
		}
		
		public function addAsset(resource:AssetResource, loader:AssetLoader):void
		{
			var currentLoader:AssetLoader = getLoader(resource.id);
			if (currentLoader != null)
			{
				return;
			}
			else{
				assetCount++;
				
				loaders[resource] = loader;
				resourceByLoader[loader] = resource;
			}
		}
		
		public function getResource(loader:AssetLoader):AssetResource
		{
			return resourceByLoader[loader];
		}
		
		public function getLoader(id:String):AssetLoader
		{
			var result:AssetLoader;
			
			for each (var resource:AssetResource in resourceByLoader)
			{
				if (resource.id == id)
				{
					result = loaders[resource];
					break;
				}
			}
			
			return result;
		}
		
		public function getAsset(id:String):Object
		{
			var loader:AssetLoader = getLoader(id);
			return loader ? loader.asset : null;
		}
		
		public function getDisplayObject(id:String):DisplayObject
		{
			var result:DisplayObject;
			var asset:DisplayObjectAsset = getAsset(id) as DisplayObjectAsset;
			if (asset)
			{
				result = asset.displayObject;
			}
			return result;
		}
		
		public function load():void
		{
			completionCount = assetCount;
			for each (var loader:AssetLoader in loaders)
			{
				
				loader.addEventListener(Event.COMPLETE, onAssetLoaderComplete);
				loader.load(resourceByLoader[loader]);
			}
		}
		
		// Internals
		//
		
		private var loaders:Dictionary;
		private var resourceByLoader:Dictionary;
		
		private var assetCount:int = 0;
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
		
		private function onAssetLoaderComplete(evt:Event):void
		{
			var loader:AssetLoader = evt.target as AssetLoader;
			var resource:AssetResource = resourceByLoader[evt.target];
			
			completionCount--;
		}
		
	}
}