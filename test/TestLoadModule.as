package 
{
	import com.tudou.events.SchedulerEvent;
	import com.tudou.net.SWFLoader;
	import com.tudou.player.config.PlayerSystem;
	import com.tudou.utils.Scheduler;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	import mx.core.FontAsset; FontAsset;
	import mx.core.ByteArrayAsset; ByteArrayAsset;
	
	import com.tudou.player.interfaces.IMediaPlayerModule; IMediaPlayerModule;
	import com.tudou.player.events.NetStatusEventLevel; NetStatusEventLevel;
	import com.tudou.player.events.NetStatusCommandCode; NetStatusCommandCode;
	import com.tudou.player.events.NetStatusEventCode; NetStatusEventCode;
	//
	import com.tudou.layout.LayoutSprite; LayoutSprite;
	import com.tudou.utils.Debug; Debug;
	import com.tudou.utils.Tween; Tween;

	/**
	 * ...
	 * @author 8088
	 */
	public class TestLoadModule extends Sprite
	{
		private var loader:SWFLoader;
		public function TestLoadModule() 
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			if (stage) onStage();
			else addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(evt:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			initStage();
			//trace(this.loaderInfo.applicationDomain.hasDefinition("com.tudou.player.skin.MediaPlayerSkin"));
			
			loadSkin("tdtv_live_orange.swf");
			
			Scheduler.setTimeout(5000, unLoadSkin);
			//
			Scheduler.setTimeout(10000, loadNewSkin);
		}
		
		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			stage.stageFocusRect = false;
			stage.frameRate	= 24;
		}
		
		private function unLoadSkin(evt:SchedulerEvent=null):void
		{
			trace("卸载！");
			if(this.contains(loader.content)) removeChild(loader.content)
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFailed);
			loader.removeEventListener(Event.COMPLETE, onLoaded);
			loader.unload();
			trace(loader.content)
			loader = null;
			trace(this.loaderInfo.applicationDomain.hasDefinition("com.tudou.player.skin.MediaPlayerSkin"));
			
		}
		
		private function loadNewSkin(evt:SchedulerEvent=null):void
		{
			trace(this.loaderInfo.applicationDomain.hasDefinition("com.tudou.player.skin.MediaPlayerSkin"));
			loadSkin("tdtv_live_blue.swf");
		}
		
		private function loadSkin(skin_url:String):void
		{
			loader = new SWFLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFailed);
			loader.addEventListener(Event.COMPLETE, onLoaded);
			
			//.\assets\blue_tdtv_theme_assets.swc
			try {
				loader.load(skin_url, new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain)));
			}
			catch (err:Error) {
				// ignore..
			};
			
		}
		
		private function onLoadFailed(evt:ErrorEvent):void
		{
			trace(evt);
		}
		
		private function onLoaded(evt:Event):void
		{
			//var orange:Object = loader.content;
			//orange.style = "left:20; top:20; width:50%; height:50%;";
			addChild(loader.content)
			
			//trace(this.loaderInfo.applicationDomain.hasDefinition("com.tudou.player.skin.MediaPlayerSkin"));
			//trace(loader.contentLoaderInfo.applicationDomain.hasDefinition("com.tudou.player.skin.MediaPlayerSkin"))
		}
		
		private function onNetStatus(evt:NetStatusEvent):void
		{
			
		}
	}

}