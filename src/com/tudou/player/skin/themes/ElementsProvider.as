package com.tudou.player.skin.themes
{
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.player.skin.widgets.WidgetLoader;
	import com.tudou.player.skin.widgets.WidgetsManager;
	import com.tudou.utils.HashMap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import com.tudou.player.skin.assets.AssetLoader;
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.skin.assets.BitmapResource;
	import com.tudou.player.skin.assets.FontResource;
	import com.tudou.player.skin.assets.SymbolResource;
	import com.tudou.player.skin.widgets.WidgetResource;

	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * ElementsProvider
	 */	
	public class ElementsProvider extends EventDispatcher
	{
		
		public function ElementsProvider(assetsManager:AssetsManager = null, widgetsManager:WidgetsManager=null)
		{
			_assetsManager = assetsManager || new AssetsManager();
			_widgetsManager= widgetsManager || new WidgetsManager();
			super();
		}
		
		public static function getInstance():ElementsProvider
		{
			instance ||= new ElementsProvider();
			return instance;
		}
		
		public function load():void
		{
			_loading = true;
			_assetsManager.addEventListener(Event.COMPLETE, loadComplete);
			_assetsManager.load();
			
			_widgetsManager.addEventListener(Event.COMPLETE, loadComplete);
			_widgetsManager.load();
		}
		
		public function get assetsManager():AssetsManager
		{
			return _assetsManager;
		}
		
		public function get widgetsManager():WidgetsManager
		{
			return _widgetsManager;
		}
		
		// Internals
		//
		
		public function addEmbeddedBitmap(id:String, symbolClass:Class, local:Boolean):void
		{
			var resource:BitmapResource
				= new BitmapResource
					( id
					, getQualifiedClassName(symbolClass)
					, local
					, null 
					);
			_assetsManager.addAsset(resource, new AssetLoader());
		}
		
		public function addEmbeddedSymbol(id:String, symbolClass:Class, local:Boolean):void
		{
			var resource:SymbolResource
				= new SymbolResource
					( id
					, getQualifiedClassName(symbolClass)
					, local
					, null
					);
			_assetsManager.addAsset(resource, new AssetLoader());
		}
		
		public function addEmbeddedWidget(widget_config:XML, area:String=null):void
		{
			var resource:WidgetResource
				= new WidgetResource
					( widget_config
					);
			_widgetsManager.addWidget(resource, new WidgetLoader(), area);
		}
		
		private function loadComplete(evt:Event):void
		{
			if (evt.target == _assetsManager) _assets_loaded = true;
			if (evt.target == _widgetsManager) _widgets_loaded = true;
			if (_assets_loaded && _widgets_loaded)
			{
				_loaded = true;
				_loading = false;
				_assets_loaded = false;
				_widgets_loaded = false;
				//Redispatch the completion event:
				dispatchEvent(evt.clone());
				_assetsManager.removeEventListener(Event.COMPLETE, loadComplete);
				_widgetsManager.removeEventListener(Event.COMPLETE, loadComplete);
				
			}
		}
		
		
		//API
		public function get loading():Boolean
		{
			return _loading;
		}
		
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		private var _assetsManager:AssetsManager;
		private var _widgetsManager:WidgetsManager;
		private static var instance:ElementsProvider;
		private var _loaded:Boolean;
		private var _assets_loaded:Boolean;
		private var _widgets_loaded:Boolean;
		private var _loading:Boolean;
	}
}