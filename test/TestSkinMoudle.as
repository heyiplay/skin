package
{
	import com.tudou.events.SchedulerEvent;
	import com.tudou.layout.LayoutSprite;
	import com.tudou.player.config.MediaData;
	import com.tudou.player.config.PlayerStatus;
	import com.tudou.player.config.PlayerConfig;
	import com.tudou.player.config.PlayerLanguage;
	import com.tudou.player.events.NetStatusEventCode;
	import com.adobe.serialization.json.JSON;
	import com.tudou.net.SWFLoader;
	import com.tudou.player.config.MediaInfo;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.MediaPlayerSkin;
	import com.tudou.player.utils.StageProxy;
	import com.tudou.ui.ShortcutKeys;
	import com.tudou.utils.Debug;
	import com.tudou.utils.FPS;
	import com.tudou.utils.Global;
	import com.tudou.utils.Scheduler;
	import com.tudou.utils.Utils;
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.FullScreenEvent;
	import flash.system.Security;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TestSkinMoudle extends LayoutSprite
	{
		public function TestSkinMoudle()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			super();
			
			style = "position:stage; width:100%; height:100%; background:#999;";
			
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			// 初始化全局状态、参数、数据、设置
			_global.language = PlayerLanguage.getInstance();
			//_global.language.addEventListener(NetStatusEvent.NET_STATUS, onLanguageChange);
			
			_global.status = PlayerStatus.getInstance();
			//_global.system = PlayerSystem.getInstance();
			//_global.system.addEventListener(NetStatusEvent.NET_STATUS, onPlayerSystemChange);
			
			_global.info = new MediaInfo();
			//_global.info.addEventListener(NetStatusEvent.NET_STATUS, onMediaInfoChange);
			
			//_global.user = new UserInfo();
			//_global.user.addEventListener(NetStatusEvent.NET_STATUS, onUserInfoChange);
			
			_global.config = new PlayerConfig();
			//_global.config.addEventListener(NetStatusEvent.NET_STATUS, onPlayerConfigChange);
			/*
			_global.config.colorMode = "剧院";
			_global.config.brightness = 0.1;
			_global.config.contrast = 0.5;
			_global.config.saturation = 0.5;
			_global.config.proportionMode = "16:9";
			_global.config.scale = .8;
			_global.config.rotationAngle = 90;
			*/
			
			//var testLoaderInfo:TestLoaderInfo = new TestLoaderInfo();
			//YoukuTudouFlashvarsTranslater.getInstance().parse(testLoaderInfo.parameters);
			
			initStage();
			
			building();
			
			
			
			Scheduler.setTimeout(1000, function(evt:SchedulerEvent):void {
				_global.config.allowPlayControls = true;
				
				var mediaData:MediaData = new MediaData();
					mediaData.id = "xx";
					mediaData.multiQuality = ["320p", "480p","720p"];
					//mediaData.multiQualityRight =  { "320p":"vip","480p":"vip","720p":"vip" };
					mediaData.quality = "320p";
				_global.info.mediaData = mediaData;
				
				//_global.config.autoHideControlBar = true;
			});
			
		}
		
		private function initStage():void
		{
			var _stage:StageProxy = new StageProxy(this);
			_stage.align = StageAlign.TOP_LEFT;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.quality = StageQuality.HIGH;
			_stage.stageFocusRect = false;
			_stage.frameRate = 25;
			_stage.addEventListener(Event.RESIZE, resize);
			_stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenChange);
			
		}
		
		private function building():void
		{
			player = new Timer(1000, 1);
			player.addEventListener(TimerEvent.TIMER, onPlayer);
			
			_skin = new MediaPlayerSkin();
			
			_skin.style = "width:100%-40;height:100%-40; top:20; left:20; background:#ccc;";
			_skin.addEventListener(NetStatusEvent.NET_STATUS, onSkinNetStatus);
			addChild(_skin as DisplayObject);
			
			var fps:FPS = new FPS();
			addChild(fps);
			
		}
		
		private function onSkinNetStatus(evt:NetStatusEvent):void
		{
			Debug.log(Utils.serialize(evt.info), "SKIN");
			switch(evt.info.level)
			{
				case NetStatusEventLevel.STATUS:
					onStatus(evt);
					break;
				case NetStatusEventLevel.NOTE:
					onNote(evt);
					break;
				case NetStatusEventLevel.ERROR:
					onError(evt);
					break;
				case NetStatusEventLevel.COMMAND:
					onCommand(evt);
					break;
			}
		}
		
		private function onStatus(evt:NetStatusEvent):void
		{
			switch(evt.info.code)
			{
				case NetStatusEventCode.SKIN_IS_READY:
					_skin.start();
					player.start();
					break;
			}
		}
		
		private function onNote(evt:NetStatusEvent):void
		{
			
		}
		
		private function onError(evt:NetStatusEvent):void
		{
			
		}
		
		private function onCommand(evt:NetStatusEvent):void
		{
			switch(evt.info.code)
			{
				case NetStatusCommandCode.SET_PLAYER_SIZE_FULLSCREEN:
					_global.status.screenChanging = true;
					if (_global.config.allowFullScreenInteractive)
					{
						_global.status.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
					}
					else {
						_global.status.displayState = StageDisplayState.FULL_SCREEN;
					}
					
					stage.displayState = _global.status.displayState;
					
					if (String(stage.displayState).indexOf("fullScreen") == -1)
					{
						Debug.log("#ERROR: 播放器外容器不允许全屏, 禁用");
					}
					Scheduler.setTimeout(500, function(evt:SchedulerEvent):void {
						if (stage) stage.mouseChildren = true;
					});
						_global.status.screenChanging = false;
					break;
				case NetStatusCommandCode.SET_PLAYER_SIZE_NARROWSCREEN:
				case NetStatusCommandCode.SET_PLAYER_SIZE_NORMAL:
				case NetStatusCommandCode.SET_PLAYER_SIZE_POPUP:
				case NetStatusCommandCode.SET_PLAYER_SIZE_WIDECREEN:
					_global.status.displayState = StageDisplayState.NORMAL;
					
					stage.displayState = _global.status.displayState;
					
					break;
				case NetStatusCommandCode.SET_ALLOW_FULL_SCREEN_INTERACTIVE:
					_global.config.allowFullScreenInteractive = evt.info.data.value;
					break;
			}
		}
		
		private function resize(evt:Event = null):void
		{
			applyStyle();
		}
		
		private function fullScreenChange(evt:Event):void
		{
			_global.status.displayState = stage.displayState;
		}
		private function onPlayer(e:TimerEvent):void
		{
			//mark:测试提示
			Scheduler.setTimeout(5000, function(evt:SchedulerEvent):void
			{
				_skin.onNetStatus(new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, 	{ code:"Player.Play.HardwareAcceleration"
						, level:NetStatusEventLevel.NOTE
						, data:{ code:"T0001", time:15000, content:"注：启动硬件加速后，无法使用 <font color='#FF6600'>色彩</font> 和 <font color='#FF6600'>旋转</font> 功能。" }
						}
					)
				);
			});
			//mark:测试错误信息
			_skin.onNetStatus(new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, 	{ code:"Player.Play.Failed"
						, level:NetStatusEventLevel.ERROR
						, data: { id:this.id, code:"E0001", desc:"测试错误信息" }
						}
					)
				);
			/*	
			_skin.setTotalTime(300)
			Scheduler.setTimeout(1000, function(evt:SchedulerEvent):void
			{
				//trace(_global.config.allowPlayControls);
				_skin.setPause(false);
				_skin.start();
				
			})
			//测试清晰度设置失败或者取消
			Scheduler.setTimeout(10000, function(evt:SchedulerEvent):void
			{
				_skin.onNetStatus(new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, 	{ code:"Quality.Set.Cancel"
						, level:NetStatusEventLevel.STATUS
						, data:{ id:"TestSkinModule", time:300 }
						}
					)
				);
			})
			*/
			/*Scheduler.setTimeout(10000, function(evt:SchedulerEvent):void
			{
				
				_skin.onNetStatus(new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, 	{ code:"Player.Is.Playing"
						, level:NetStatusEventLevel.STATUS
						, data:{ id:"TestSkinModule", time:300 }
						}
					)
				);
				_skin.onNetStatus(new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, 	{ code:"Player.Is.Loading"
						, level:NetStatusEventLevel.STATUS
						, data:{ id:"TestSkinModule", loaded:1 }
						}
					)
				);
				_skin.onNetStatus(new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, 	{ code:"Player.Play.End"
						, level:NetStatusEventLevel.STATUS
						, data:{ id:"TestSkinModule" }
						}
					)
				);
			})
			*/
			
			/*
			var _time:Number = 0.0;
			var _loaded:Number = 0.0;
			Scheduler.setInterval(150, function(evt:SchedulerEvent):void
			{
				_skin.onNetStatus(new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, 	{ code:"Player.Is.Playing"
						, level:NetStatusEventLevel.STATUS
						, data:{ id:"TestSkinModule", time:(_time++)/2 }
						}
					)
				);
				_skin.onNetStatus(new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, 	{ code:"Player.Is.Loading"
						, level:NetStatusEventLevel.STATUS
						, data:{ id:"TestSkinModule", loaded:(_loaded++)/10 }
						}
					)
				);
			});
			*/
			
		}
		
		private var player:Timer;
		private var _skin:MediaPlayerSkin;
		
	}
	
	
}