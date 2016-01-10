package com.tudou.player.skin.assets
{
	import com.tudou.player.skin.MediaPlayerSkin;
	import com.tudou.utils.Debug;
	import flash.utils.getDefinitionByName;
	
	import com.tudou.player.skin.assets.iconfont.TIcon;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	[Event(name = "complete", type = "flash.events.Event")]
	
	public class AssetLoader extends EventDispatcher
	{
		public function load(resource:AssetResource):void
		{
			this.resource = resource;
			
			if (resource.local == false)
			{
				if	(	resource is BitmapResource
					||	resource is FontResource
					||	resource is SymbolResource
					)
				{
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
					
					loader.load(new URLRequest(resource.url), new LoaderContext(true));
				}
			}
			else
			{
				_asset = constructLocalAsset();
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function get asset():Object
		{
			return _asset; 
		}
		
		protected var resource:AssetResource;
		private var _asset:Object;
		
		protected function onLoaderError(event:IOErrorEvent):void
		{
			Debug.log("警告:从"+ resource.url+" 加载 asset 失败，资源ID:"+ resource.id, 0xFFBB33);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function onLoaderComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			
			_asset = constructLoadedAsset(loaderInfo);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function constructLoadedAsset(loaderInfo:LoaderInfo):Object
		{
			var asset:Object;
			var type:Class;
			
			if (resource is FontResource)
			{
				type = loaderInfo.applicationDomain.getDefinition(FontResource(resource).symbol) as Class; 
				asset = new FontAsset(type, resource as FontResource);
			}
			else if (resource is BitmapResource){
				if (loaderInfo.contentType == "application/x-shockwave-flash")
				{
					asset = new SWFAsset(loaderInfo.content);
				}
				else if (loaderInfo.contentType != ""){
					asset 
						= new BitmapAsset
							( loaderInfo.content as Bitmap
							, resource is BitmapResource
								? BitmapResource(resource).scale9
								: null
							);
				}
			}
			else if (resource is SymbolResource){
				type = loaderInfo.applicationDomain.getDefinition(SymbolResource(resource).symbol) as Class; 
				asset = new SymbolAsset(type);
			}
			
			return asset;
		}
		
		protected function constructLocalAsset():Object
		{
			var asset:Object;
			var type:Class;
			
			if (resource is IconfontResource)
			{
				asset = new IconfontAsset(
					TIcon.getIntance().icon(String.fromCharCode((resource as IconfontResource).iconText), 
							{ color: (resource as IconfontResource).iconColor
							, bgWidth: (resource as IconfontResource).width
							, bgHeight: (resource as IconfontResource).height
							, iconWidth: (resource as IconfontResource).iconWidth
							} )
				);
				return asset;
			}
			
			try
			{
				type = getDefinitionByName(resource.url) as Class;
			}
			catch(error:Error){
				Debug.log("警告: 无法实例化 asset:" + error.message, 0xFFBB33);	
			}
			
			if (type != null)
			{
				if (resource is BitmapResource)
				{
					var bitmap:* = new type();
					if (bitmap is BitmapData)
					{
						bitmap = new Bitmap(bitmap);
					}
					asset = new BitmapAsset(bitmap, BitmapResource(resource).scale9);
				}
				else if (resource is FontResource){
					asset = new FontAsset(type, resource as FontResource);
				}
				else if (resource is SymbolResource){
					asset = new SymbolAsset(type);
				}
				else{
					Debug.log("警告: 没有发现 asset 类型 "+resource.id, 0xFFBB33);
				}
			}
			else{
				Debug.log("警告: asset加载失败 "+resource.id, 0xFFBB33);
			}
			
			return asset;
		}
	}
}