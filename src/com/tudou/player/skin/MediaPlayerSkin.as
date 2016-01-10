package com.tudou.player.skin
{
	import com.tudou.net.SWFLoader;
	import com.tudou.player.config.ColorMode;
	import com.tudou.player.config.StreamType;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.events.NetStatusEventCode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.interfaces.IMediaPlayerModule;
	import com.tudou.player.skin.configuration.ListType;
	import com.tudou.player.skin.configuration.SizeMode;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.configuration.Configurator;
	import com.tudou.player.skin.themes.BottomArea;
	import com.tudou.player.skin.themes.ElementsProvider;
	import com.tudou.player.skin.themes.LeftArea;
	import com.tudou.player.skin.themes.MiddleArea;
	import com.tudou.player.skin.themes.RightArea;
	import com.tudou.player.skin.themes.TopArea;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.assets.XMLAsset;
	import com.tudou.layout.LayoutSprite;
	import com.tudou.player.skin.themes.ykws.SetHintInformation;
	import com.tudou.player.skin.widgets.SetHintMediator;
	import com.tudou.ui.ShortcutKeys;
	import com.tudou.ui.RightMenu;
	import com.tudou.utils.Debug;
	import com.tudou.utils.Scheduler;
	import com.tudou.utils.Utils;
	import com.tudou.utils.Version;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.system.Security;
	import flash.display.StageDisplayState;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.ui.Mouse;
	
	import com.tudou.player.skin.widgets.*;
	
	/**
	 * 媒体播放器皮肤,根据配置编译不同的皮肤
	 * 
	 * @author 8088
	 */
	public class MediaPlayerSkin extends LayoutSprite implements IMediaPlayerModule
	{
		
		[Embed(CONFIG::SKIN_CONFIG, mimeType="application/octet-stream")]
		private const Config:Class;
		
		public function MediaPlayerSkin():void 
		{
			super();
			
			style = default_style;
			
			this.id = "MediaPlayerSkin";
			
			//0.监听皮肤关心的全局变量
			if (_global.info) _global.info.addEventListener(NetStatusEvent.NET_STATUS, onMediaInfoChange);
			if (_global.user) _global.user.addEventListener(NetStatusEvent.NET_STATUS, onUserInfoChange);
			if (_global.config) _global.config.addEventListener(NetStatusEvent.NET_STATUS, onPlayerConfigChange);
			if (_global.system) _global.system.addEventListener(NetStatusEvent.NET_STATUS, onPlayerSystemChange);
			if (_global.status) _global.status.addEventListener(NetStatusEvent.NET_STATUS, onPlayerStatusChange);
			
			if (_global.core) _global.core.addEventListener(NetStatusEvent.NET_STATUS, onCoreStateChange);
			if (_global.ad) _global.ad.addEventListener(NetStatusEvent.NET_STATUS, onAdChange);
			
		}
		
		override protected function onStage(evt:Event = null):void
		{
			if (this.parent == this.stage) initStage();
			
			super.onStage(evt);
			
			resetMask();
			
			//1.初始化配置器。
			var configfile:XMLAsset = new XMLAsset(Config);
			var configurator:Configurator = new Configurator();
			configurator.addEventListener(Event.COMPLETE, onConfigComplete);
			configurator.parseConfig(configfile.xml);
			
		}
		
		override public function setSize():void
		{
			super.setSize();
			if (setInformation && setInformation.hasOwnProperty("layout")) setInformation["layout"]();
			if (this.width > 0 && this.height > 0) resetMask();
			
			if (_global.status.displayState !=_size_mode)
			{
				onSizeModeChange(_global.status.displayState);
			}
		}
		
		
		
		private function resetMask():void
		{
			if (skin_mask)
			{
				skin_mask.width = this.width;
				skin_mask.height = this.height;
			}
			else {
				skin_mask = new Shape();
				skin_mask.graphics.beginFill(0xffffff, 1);
				skin_mask.graphics.drawRect(0, 0, this.width, this.height);
				skin_mask.graphics.endFill();
				addChild(skin_mask);
				this.mask = skin_mask;
			}
		}
		
		private function onConfigComplete(evt:Event = null):void
		{
			skin_config = (evt.target as Configurator).data;
			
			//皮肤信息
			_info.theme = String(skin_config.@name).toUpperCase();
			_info.version = String(skin_config.@version);
			_info.author =  String(skin_config.@author);
			_info.id = this.id;
			
			//2.确保UI元素池完工。
			elements_provider = ElementsProvider.getInstance();
			elements_provider.addEventListener(Event.COMPLETE, onElementsProviderComplete);
			if (elements_provider.loaded == false && elements_provider.loading == false)
			{
				elements_provider.load();
			}
			else{
				onElementsProviderComplete();
			}
		}
		
		private function onElementsProviderComplete(evt:Event = null):void
		{
			//3.根据配置分别构建各区域
			
			if (elements_provider.widgetsManager.middle.length > 0)
			{
				middle_area = new MiddleArea(elements_provider.widgetsManager.middle);
				middle_area.style = skin_config.middlearea.@style;
				middle_area.hideStyle = skin_config.middlearea.@hidestyle;
				middle_area.showStyle = skin_config.middlearea.@showstyle;
				middle_area.autoHide = skin_config.middlearea.@autohide == "true"? true:false;
				middle_area.addEventListener(NetStatusEvent.NET_STATUS, onSelfNetStatus);
				addChild(middle_area);
			}
			
			if (elements_provider.widgetsManager.left.length > 0)
			{
				left_area = new LeftArea(elements_provider.widgetsManager.left);
				left_area.style = skin_config.leftarea.@style;
				left_area.hideStyle = skin_config.leftarea.@hidestyle;
				left_area.showStyle = skin_config.leftarea.@showstyle;
				left_area.autoHide = skin_config.leftarea.@autohide == "true"? true:false;
				left_area.addEventListener(NetStatusEvent.NET_STATUS, onSelfNetStatus);
				addChild(left_area);
			}
			
			if (elements_provider.widgetsManager.right.length > 0)
			{
				right_area = new RightArea(elements_provider.widgetsManager.right);
				right_area.style = skin_config.rightarea.@style;
				right_area.hideStyle = skin_config.rightarea.@hidestyle;
				right_area.showStyle = skin_config.rightarea.@showstyle;
				right_area.autoHide = skin_config.rightarea.@autohide == "true"? true:false;
				right_area.addEventListener(NetStatusEvent.NET_STATUS, onSelfNetStatus);
				addChild(right_area);
			}
			
			if (elements_provider.widgetsManager.top.length > 0)
			{
				top_area = new TopArea(elements_provider.widgetsManager.top);
				top_area.style = skin_config.toparea.@style;
				top_area.hideStyle = skin_config.toparea.@hidestyle;
				top_area.showStyle = skin_config.toparea.@showstyle;
				top_area.autoHide = skin_config.toparea.@autohide == "true"? true:false;
				top_area.addEventListener(NetStatusEvent.NET_STATUS, onSelfNetStatus);
				addChild(top_area);
			}
			
			if (elements_provider.widgetsManager.bottom.length>0)
			{
				bottom_area = new BottomArea(elements_provider.widgetsManager.bottom);
				bottom_area.style = skin_config.bottomarea.@style;
				bottom_area.hideStyle = skin_config.bottomarea.@hidestyle;
				bottom_area.showStyle = skin_config.bottomarea.@showstyle;
				bottom_area.autoHide = skin_config.bottomarea.@autohide == "true"? true:false;
				bottom_area.addEventListener(NetStatusEvent.NET_STATUS, onSelfNetStatus);
				addChild(bottom_area);
			}
			
			initialization();
		}
		
		//4.初始化UI
		private function initialization():void
		{
			/*
			 * 中间区域
			 */
			if (middle_area)
			{
				firstLoadWidget = middle_area.getWidget("FirstLoadWidget");
				bufferLoadWidget = middle_area.getWidget("BufferLoadWidget");
				setInformation = middle_area.getWidget("SetHintInformation");
				errorPanel = middle_area.getWidget("ErrorPanel");
				paidTimeoutPanel=middle_area.getWidget("PaidTimeoutPanel");
				privacyPanel = middle_area.getWidget("PrivacyPanel");
				setPanel = middle_area.getWidget("SetPanel");
				shorcutKeysPanel = middle_area.getWidget("ShorcutKeysPanel");
				
				largeButton = middle_area.getWidget("LargeButton");
				playList = middle_area.getWidget("PlayList");
				setHintInfo();
			}
			
			/*
			 * 左边区域
			 */
			if (left_area)
			{
				//...
			}
			
			/*
			 * 右边区域
			 */
			if (right_area)
			{
				rightAreaShareButton = right_area.getWidget("RightAreaShareButton");
				toggleOffLightButton = right_area.getWidget("ToggleOffLightButton");
				rightAreaCommentButton = right_area.getWidget("RightAreaCommentButton");
				rightAreaDanmuButton = right_area.getWidget("ToggleRightAreaDanmuButton");
				rightAreaCloudButton = right_area.getWidget("RightAreaCloudButton");
			}
			
			/*
			 * 顶部区域
			 */
			if (top_area)
			{
				videoTitleLabel = top_area.getWidget("VideoTitleLabel");
				toggleScaleWidget = top_area.getWidget("ToggleScaleWidget");
				searchWidget = top_area.getWidget("SearchWidget");
				localTime = top_area.getWidget("LocalTime");
				playListButton = top_area.getWidget("PlayListButton");
				exitFullScreenButton = top_area.getWidget("ExitFullScreenButton");
				rotationAndScale = top_area.getWidget("RotationAndScale");
			}
			
			/*
			 * 底部区域
			 */
			if (bottom_area)
			{
				informationWidget = bottom_area.getWidget("InformationWidget");
				scrubBar = bottom_area.getWidget("ScrubBar");
				toggleStopButton = bottom_area.getWidget("ToggleStopButton");
				togglePauseButton = bottom_area.getWidget("TogglePauseButton");
				rePlayButton = bottom_area.getWidget("RePlayButton");
				reConnectButton = bottom_area.getWidget("ReConnectButton");
				playListNextButton = bottom_area.getWidget("PlayListNextButton");
				videoTimeLabel = bottom_area.getWidget("VideoTimeLabel");
				shareButton = bottom_area.getWidget("ShareButton");
				volumeWidget = bottom_area.getWidget("VolumeWidget");
				toggleLanguageButton = bottom_area.getWidget("ToggleLanguageButton");
				toggleClarityButton = bottom_area.getWidget("ToggleClarityButton");
				toggleQualityButton = bottom_area.getWidget("ToggleQualityButton");
				demandListButton=bottom_area.getWidget("DemandListButton");
				settingsButton = bottom_area.getWidget("SettingsButton");
				danmuButton = bottom_area.getWidget("DanmuButton");
				recommendButton = bottom_area.getWidget("RecommendButton");
				toggleWideScreenButton=bottom_area.getWidget("ToggleWideScreenButton");
				toggleFullScreenButton = bottom_area.getWidget("ToggleFullScreenButton");
				
				if (_total_time > 0&&scrubBar.hasOwnProperty("playProgress")) scrubBar["playProgress"] = _playe_time / _total_time;
			}
			
			/*
			 * 初始化完成，通知播放器皮肤已就绪
			 */
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:SkinNetStatusEventCode.SKIN_IS_READY, level:NetStatusEventLevel.STATUS, data:_info }
				)
			);
		}
		
		/**
		 * 重置皮肤
		 */
		public function reset():void
		{
			//关闭所有已显示的面板
			if (errorPanel && errorPanel.visible) errorPanel.visible = false;
			if (setPanel && setPanel.visible) setPanel.visible = false;
			if (shorcutKeysPanel && shorcutKeysPanel.visible) shorcutKeysPanel.visible = false;
		}
		
		public function start():void
		{
			//启动时先重置
			this.reset();
			
			this.onCoreStateChange();
			
			if (_global.config)
			{
				setPlayControls(_global.config.allowPlayControls);
			}
			
			if (_global.system)
			{
				if(setPanel&&setPanel.hasOwnProperty("setAllowFullScreenInteractiveEnabled")) setPanel["setAllowFullScreenInteractiveEnabled"](_global.system.allowFullScreenInteractive);
			}
			
			if (_global.core)
			{
				setTotalTime(_global.core.getDuration());
				setBuffer(_global.core.getLoadedFraction());
				setPlayTime(_global.core.getCurrentTime());
			}
			
			//按数据初始化各控件
			if (_global.info && _global.info.mediaData)
			{
				onCurrentPlayMeidaDataChange(_global.info.mediaData);
			}
			
			//按配置初始化各控件
			if (_global.config)
			{
				//弹幕按钮
				if (danmuButton) {
					danmuButton.visible = _global.config.hasDanmu;
					danmuButton["open"] = _global.config.openDanmu;
				}
				
				//音量控件
				setVolume(_global.config.volume);
				
				//控制条
				if (_global.config.autoHideControlBar) bottom_area.autoHide =  _global.config.autoHideControlBar;
				
				//设置面板
				setAllowFullScreenInteractive(_global.config.allowFullScreenInteractive);
				if (_global.config.colorMode != ColorMode.CUSTOM)
				{
					setColorMode(_global.config.colorMode);
				}
				else {
					setBrightness(_global.config.brightness);
					setContrast(_global.config.contrast);
					setSaturation(_global.config.saturation);
				}
				setProportionMode(_global.config.proportionMode);
				if (setPanel)
				{
					if(setPanel.hasOwnProperty("setHardwareAccelerateEnabled")) setPanel["setHardwareAccelerateEnabled"](_global.config.allowHardwareAccelerateSet);
					if(setPanel.hasOwnProperty("setProportionEnabled")) setPanel["setProportionEnabled"](_global.config.allowProportionSet);
					if(setPanel.hasOwnProperty("setRotationEnabled")) setPanel["setRotationEnabled"](_global.config.allowRotationSet);
					if(setPanel.hasOwnProperty("setScaleEnabled")) setPanel["setScaleEnabled"](_global.config.allowScaleSet);
				}
				if(_global.config.allowHardwareAccelerateSet) setHardwareAccelerate(_global.config.hardwareAccelerate);
				
				setScale(_global.config.scale);
				setRotationAngle(_global.config.rotationAngle);
				//mark:确认重置需要放到所有设置项最后
				if (setPanel && setPanel.hasOwnProperty("reset")) setPanel["reset"]();
			}
			
		}
		
		public function onNetStatus(evt:NetStatusEvent):void
		{
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
		
		private function onSelfNetStatus(evt:NetStatusEvent):void
		{
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
			
			dispatchEvent(evt);
			
		}
		
		private function onStatus(evt:NetStatusEvent):void
		{
			switch (evt.info.code)
			{
				case NetStatusEventCode.AD_SHOW_START:
					if (evt.info.data.phase == 'before') setPlayControls(_global.config.allowPlayControls);
					break;
				case NetStatusEventCode.PLAYER_PLAY_START:
					setTotalTime(_global.core.getDuration());
					break;
				case NetStatusEventCode.PLAYER_IS_PLAYING:
					setPlayTime(evt.info.data.time);
					break;
				case NetStatusEventCode.PLAYER_IS_LOADING:
					setBuffer(evt.info.data.loaded);
					break;
				case NetStatusEventCode.QUALITY_SET_FAILED:
				case NetStatusEventCode.QUALITY_SET_CANCEL:
					setResolution(_global.info.mediaData.quality);
					break;
				case SkinNetStatusEventCode.SCRUBBAR_SLIDER_START:
					setMouseEnabled(false);
					break;
				case SkinNetStatusEventCode.SCRUBBAR_SLIDER_END:
					setMouseEnabled(true);
					break;
				case SkinNetStatusEventCode.PRIVACY_CONTACT_OWNER:
					navigateToUrl(new URLRequest(evt.info.level + "?itemid=" + _global.info.mediaId), "_blank")
					break;
				case SkinNetStatusEventCode.PRIVACY_SEARCH_RELATED:
					navigateToUrl(new URLRequest(evt.info.level + encodeURIComponent(_global.info.mediaTitle)), "_blank")
					break;
				case SkinNetStatusEventCode.SET_PANEL_TWEEN_TO_SHOW:
					
					break;
				case SkinNetStatusEventCode.SET_PANEL_TWEEN_TO_HIDE:
					//checkRightAreaShow();
					break;
				case SkinNetStatusEventCode.CONTROL_AREA_TWEEN_END:
					if (_global.status.displayState != StageDisplayState.NORMAL)
					{
						var t:Boolean = true;
						var b:Boolean = true;
						var l:Boolean = true;
						var r:Boolean = true;
						if (top_area) t = top_area.hide;
						if (bottom_area) b = bottom_area.hide;
						if (left_area) l = left_area.hide;
						if (right_area) r = right_area.hide;
						
						if (t && b && l && r) Mouse.hide();
					}
					break;
			}
		}
		
		private function onNote(evt:NetStatusEvent):void
		{
			if (!evt.info.data) return;
			var info:String = evt.info.data.content;
			if (!info || info == "") return;
			var autoHide:Boolean = evt.info.data.hasOwnProperty("autoHide")?evt.info.data.autoHide:true;
			var autoHideTimeout:Number = evt.info.data.hasOwnProperty("time")? evt.info.data.time:5000;
			if (evt.info.data.type&&evt.info.data.type=="guide") showUserGuide(info, autoHide, autoHideTimeout);
			else showInfo(info, autoHide, autoHideTimeout);
			
		}
		
		private function onError(evt:NetStatusEvent):void
		{
			if (!evt.info.data) return;
			
			var err_code:String = evt.info.data.code;
			var err_message:String = evt.info.data.desc;
			
			showError(err_code, err_message);
		}
		
		//mark:命令上报后 要等回执，再调整状态
		private function onCommand(evt:NetStatusEvent):void
		{
			switch (evt.info.code)
			{
				case NetStatusCommandCode.SET_PLAYER_SIZE_NORMAL:
					onSizeModeChange(SizeMode.NORMAL);
					break;
				case NetStatusCommandCode.SET_PLAYER_SIZE_FULLSCREEN:
					if (stage) stage.mouseChildren = false;
					break;
				case NetStatusCommandCode.PLAY:
					if (_global.core&&_global.core.state == "error")
					{
						showLoading(true);
						this.reset();
					}
					break;
				case NetStatusCommandCode.RECONNECT:
					showLoading(true);
					this.reset();
					break;
				case NetStatusCommandCode.REPLAY:
					setReplay(true);
					break;
				case NetStatusCommandCode.CHANGE_QUALITY:
					setResolution(evt.info.data.value);
					break;
				case NetStatusCommandCode.SET_QUALITY:
					setResolution(evt.info.data.value);
					break;
				case NetStatusCommandCode.PAUSE:
					setPause(true);
					break;
				case NetStatusCommandCode.RESUME:
					if (rePlayButton&&rePlayButton.visible) return;
					setPause(false);
					break;
				case NetStatusCommandCode.SEARCH:
					navigateToUrl(new URLRequest(evt.info.level), "_blank");
					break;
				case NetStatusCommandCode.HIDE_PLAY_LIST:
					if (playList) playList.visible=false;
					break;
				case NetStatusCommandCode.SHOW_PLAY_LIST:
					top_area.autoHide=false;
					if (playList)
					{
						playList.visible=true;
						middle_area.setChildIndex(playList, middle_area.numChildren - 1); //确保playList在最上方
					}
					break;				
				case NetStatusCommandCode.HIDE_SHOW_SHORCUTKEYS_PANEL:
					HideShowhorcutKeysPanel(evt.info.data.value);
					break;
				case NetStatusCommandCode.TOGGLE_HIDE_SHOW_SET_PANEL:
					toggleHideShowSetPanel();
					break;
				case NetStatusCommandCode.SHOW_SET_PANEL:
					showSetPanel(true, "色彩");
					break;
				case NetStatusCommandCode.OPEN_DANMU:
					if(evt.info.data.id!="DanmuButton") danmuButton["open"] = true;
					break;
				case NetStatusCommandCode.CLOSE_DANMU:
					if(evt.info.data.id!="DanmuButton") danmuButton["open"] = false;
					break;
				case NetStatusCommandCode.SET_ALLOW_FULL_SCREEN_INTERACTIVE:
					if(evt.info.data.id!="SetPanel") setAllowFullScreenInteractive(evt.info.data.value);
					break;
				case NetStatusCommandCode.SET_HARDWARE_ACCELERATE:
					if(evt.info.data.id!="SetPanel") setHardwareAccelerate(evt.info.data.value);
					break;
				case NetStatusCommandCode.SET_COLOR_MODE:
					if(evt.info.data.id!="SetPanel") setColorMode(evt.info.data.value);
					break;
				case NetStatusCommandCode.SET_COLOR_BRIGHTNESS:
					if(evt.info.data.id!="SetPanel" && evt.info.data.id!="SettingsButton") setBrightness(evt.info.data.value);
					break;
				case NetStatusCommandCode.SET_COLOR_CONTRAST:
					if(evt.info.data.id!="SetPanel") setContrast(evt.info.data.value);
					break;
				case NetStatusCommandCode.SET_COLOR_SATURATION:
					if(evt.info.data.id!="SetPanel") setSaturation(evt.info.data.value);
					break;
				case NetStatusCommandCode.SET_PROPORTION_MODE:
					if(evt.info.data.id!="SetPanel" && evt.info.data.id!="SettingsButton") setProportionMode(evt.info.data.value);
					break;
				case NetStatusCommandCode.SET_SCALE:
					if(evt.info.data.id!="SetPanel" && evt.info.data.id!="ToggleScaleWidget") setScale(evt.info.data.value);
					break;
				case NetStatusCommandCode.SET_ROTATION_ANGLE:
					if(evt.info.data.id!="SetPanel" && evt.info.data.id!="SettingsButton") setRotationAngle(evt.info.data.value);
					break;
				case NetStatusCommandCode.VOLUME_DOWN:
				case NetStatusCommandCode.VOLUME_UP:
					var data:Object = evt.info.data;
					if (data == null) data = new Object();
					data.value = _global.config.volume;
					evt.info.data = data;
					break;
			}
			if(setHintMediator &&  ((_global.ad == null) || !_global.ad.isAdTime())) setHintMediator.onCommand(evt);
		}
		
		/**
		 * 处理媒体信息变化
		 * @param	evt
		 */
		private function onMediaInfoChange(evt:NetStatusEvent):void
		{
			switch(evt.info.data.name)
			{
				case "mediaData":
					onCurrentPlayMeidaDataChange(_global.info.mediaData);
					break;
				case "mediaData.type":
					onStreamTypeChange(_global.info.mediaData.type);
					break;
				case "mediaData.multiQuality":
					setMultiResolution(_global.info.mediaData.multiQuality);
					break;
				case "mediaData.multiQualityRight":
					setMultiResolutionRight(_global.info.mediaData.multiQualityRight);
					break;
				case "mediaData.quality":
					setResolution(_global.info.mediaData.quality);
					break;
				case "mediaData.panorama":
					setPanorama(_global.info.mediaData.panorama);
					break;
				case "mediaData.duration":
					setTotalTime(_global.info.mediaData.duration);
					break;
			}
		}
		
		private function onCurrentPlayMeidaDataChange(data:Object):void
		{
			if (data)
			{
				if (data.type != null) onStreamTypeChange(data.type);
				if (data.multiQuality != null) setMultiResolution(data.multiQuality);
				if (data.multiQualityRight != null) setMultiResolutionRight(data.multiQualityRight);
				if (data.quality != null) setResolution(data.quality);
				if (!isNaN(data.duration)) setTotalTime(data.duration);
				if (data.panorama > 0) setPanorama(data.panorama);
			}
		}
		
		
		/**
		 * 处理用户信息变化
		 * @param	evt
		 */
		private function onUserInfoChange(evt:NetStatusEvent):void
		{
			//mark:皮肤暂不需要监听用户信息的变化。
		}
		
		/**
		 * 处理播放器配置变化
		 * @param	evt
		 */
		private function onPlayerConfigChange(evt:NetStatusEvent):void
		{
			switch(evt.info.data.name)
			{
				case "allowPlayControls":
					setPlayControls(_global.config.allowPlayControls);
					break;
				case "allowHardwareAccelerateSet":
					if(setPanel&&setPanel.hasOwnProperty("setHardwareAccelerateEnabled")) setPanel["setHardwareAccelerateEnabled"](_global.config.allowHardwareAccelerateSet);
					break;
				case "allowProportionSet":
					if(setPanel&&setPanel.hasOwnProperty("setProportionEnabled")) setPanel["setProportionEnabled"](_global.config.allowProportionSet);
					break;
				case "allowRotationSet":
					if(setPanel&&setPanel.hasOwnProperty("setRotationEnabled")) setPanel["setRotationEnabled"](_global.config.allowRotationSet);
					break;
				case "allowScaleSet":
					if(setPanel&&setPanel.hasOwnProperty("setScaleEnabled")) setPanel["setScaleEnabled"](_global.config.allowScaleSet);
					break;
				case "volume":
					setVolume(_global.config.volume);
					break;
				case "hasDanmu":
					if (danmuButton) {
						danmuButton.visible = _global.config.hasDanmu;
					}
					break;
				case "openDanmu":
					if (danmuButton) {
						danmuButton["open"] = _global.config.openDanmu;
					}
					break;
				case "autoHideControlBar":
					if (bottom_area) bottom_area.autoHide =  _global.config.autoHideControlBar;
					break;
				case "colorMode":
					setColorMode(_global.config.colorMode);
					break;
				case "brightness":
					setBrightness(_global.config.brightness)
					break;
				case "contrast":
					setContrast(_global.config.contrast)
					break;
				case "saturation":
					setSaturation(_global.config.saturation)
					break;
				case "proportionMode":
					setProportionMode(_global.config.proportionMode);
					break;
				case "scale":
					setScale(_global.config.scale);
					break;
				case "rotationAngle":
					setRotationAngle(_global.config.rotationAngle);
					break;
			}
		}
		
		/**
		 * 处理播放器配置变化
		 * @param	evt
		 */
		private function onPlayerSystemChange(evt:NetStatusEvent):void
		{
			switch(evt.info.data.name)
			{
				case "allowFullScreenInteractive":
					if(setPanel&&setPanel.hasOwnProperty("setAllowFullScreenInteractiveEnabled")) setPanel["setAllowFullScreenInteractiveEnabled"](_global.system.allowFullScreenInteractive);
					break;
			}
		}
		
		/**
		 * 处理播放器状态变化
		 * @param	evt
		 */
		private function onPlayerStatusChange(evt:NetStatusEvent):void
		{
			switch(evt.info.data.name)
			{
				case "displayState":
					onSizeModeChange(_global.status.displayState);
					break;
			}
		}
		
		/**
		 * 处理核心状态变化造成的皮肤的变化
		 * @param	evt
		 */
		private function onCoreStateChange(evt:NetStatusEvent=null):void
		{
			if (_global.core == null) return;
			
			switch (_global.core.state)
			{
				case "notstart":
					//showLoading(false);
					setPause(true);
					setBuffer(0);
					setPlayTime(0);
					break;
				case "start":
					showLoading(true);
					setPlayControls(_global.config.allowPlayControls);
					break;
				case "playstart":
					showLoading(false);
					break;
				case "playing":
					setPause(false);
					showLoading(false);
					break;
				case "paused":
					setPause(true);
					showLoading(false);
					break;
				case "buffering":
				case "pausedbuffering":
					showLoading(true);
					break;
				case "seeking":
				case "pausedseeking":
					break;
				case "error":
					showLoading(false);
					setPause(true);
					break;
				case "playend":
					showLoading(false);
					setReplay(false);
					break;
			}
		}
		
		/**
		 * 处理核心状态变化造成的皮肤的变化
		 * @param	evt
		 */
		private function onAdChange(evt:NetStatusEvent=null):void
		{
			if (_global.ad == null) return;
			
			switch (evt.info.code)
			{
				case "Ad.Volume.Change":
				case "Ad.State.Change":
					if (_global.ad.isAdTime()) setVolume(_global.ad.volume);
					else {
						if(_global.config) setVolume(_global.config.volume);
					}
					break;
			}
		}
		
		/**
		 * 处理尺寸模式变化
		 * 
		 * @param	mode
		 * @see com.tudou.player.skin.configuration.SizeMode
		 */
		private function onSizeModeChange(mode:String):void
		{
			if (mode == _size_mode) return;
			
			var _isFullscreen:Boolean = (mode == SizeMode.FULL_SCREEN || mode == SizeMode.FULL_SCREEN_INTERACTIVE);
			
			// 设置区域
			if (top_area)
			{
				if (top_area.visible) top_area.onSizeModeChange(mode);
				top_area.visible = (_isFullscreen && top_area.enabled)? true:false;
			}
			
			if (bottom_area)
			{
				bottom_area.onSizeModeChange(mode);
				bottom_area.autoHide = _isFullscreen ? true : _global.config.autoHideControlBar;
				
				if (_isFullscreen) bottom_area.style= "bottom:"+(-bottom_area.height)+";"
				else bottom_area.style = skin_config.bottomarea.@style;
			}
			
			if (right_area)
			{
				right_area.onSizeModeChange(mode);
			}
			
			if (left_area)
			{
				left_area.onSizeModeChange(mode);
			}
			
			// 设置控件
			if (toggleWideScreenButton && toggleWideScreenButton.hasOwnProperty("wideScreen"))
			{
				if (mode == SizeMode.WIDE_SCREEN) toggleWideScreenButton["wideScreen"] = true;
				else if (mode == SizeMode.NARROW_SCREEN) toggleWideScreenButton["wideScreen"] = false;
			}
			
			if (toggleFullScreenButton && toggleFullScreenButton.hasOwnProperty("mode")) toggleFullScreenButton["mode"] = mode;
			if (danmuButton && danmuButton.hasOwnProperty("mode")) danmuButton["mode"] = mode;
			
			if (scrubBar && scrubBar.hasOwnProperty("mini")) scrubBar["mini"] = !_isFullscreen;
			
			if (!_isFullscreen)
			{
				if (playList) playList.visible = false;
			}
			
			
			_size_mode = mode;
			
			
		}
		
		/**
		 * @private
		 * 初始化场景应由最外部设置
		 */
		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			stage.stageFocusRect = false;
			stage.frameRate	= DEFAULT_FRAME_RATE;
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			style = "position:stage;"
		}
		
		private function stageResizeHandler(evt:Event):void
		{
			applyStyle();
		}
		
		private function setMouseEnabled(b:Boolean):void
		{
			if (togglePauseButton && togglePauseButton.enabled)
			{
				togglePauseButton.mouseChildren = b;
				togglePauseButton.mouseEnabled = b;
			}
			if (toggleStopButton && toggleStopButton.enabled)
			{
				toggleStopButton.mouseChildren = b;
				toggleStopButton.mouseEnabled = b;
			}
			if (rePlayButton && rePlayButton.enabled)
			{
				rePlayButton.mouseChildren = b;
				rePlayButton.mouseEnabled = b;
			}
			if (reConnectButton && reConnectButton.enabled)
			{
				reConnectButton.mouseChildren = b;
				reConnectButton.mouseEnabled = b;
			}
			if (playListNextButton && playListNextButton.enabled)
			{
				playListNextButton.mouseChildren=b;
				playListNextButton.mouseEnabled=b;
			}
			if (shareButton && shareButton.enabled)
			{
				shareButton.mouseChildren = b;
				shareButton.mouseEnabled = b;
			}
			if (volumeWidget && volumeWidget.enabled)
			{
				volumeWidget.mouseChildren = b;
				volumeWidget.mouseEnabled = b;
			}
			if (toggleLanguageButton && toggleLanguageButton.enabled)
			{
				toggleLanguageButton.mouseChildren=b;
				toggleLanguageButton.mouseEnabled=b;
			}
			if (toggleClarityButton && toggleClarityButton.enabled)
			{
				toggleClarityButton.mouseChildren = b;
				toggleClarityButton.mouseEnabled = b;
			}
			if (toggleQualityButton && toggleQualityButton.enabled)
			{
				toggleQualityButton.mouseChildren = b;
				toggleQualityButton.mouseEnabled = b;
			}
			if (demandListButton && demandListButton.enabled)
			{
				demandListButton.mouseChildren=b;
				demandListButton.mouseEnabled=b;
			}
			if (repeatButton && repeatButton.enabled)
			{
				repeatButton.mouseChildren=b;
				repeatButton.mouseEnabled=b;
			}
			if (settingsButton && settingsButton.enabled)
			{
				settingsButton.mouseChildren = b;
				settingsButton.mouseEnabled = b;
			}
			if (toggleWideScreenButton && toggleWideScreenButton.enabled)
			{
				toggleWideScreenButton.mouseChildren=b;
				toggleWideScreenButton.mouseEnabled=b;
			}
			if (toggleFullScreenButton && toggleFullScreenButton.enabled)
			{
				toggleFullScreenButton.mouseChildren = b;
				toggleFullScreenButton.mouseEnabled = b;
			}
		}
		
		
		/**
		 * 设置局部禁用，在元素池的widgets管理者中，根据ID可以找到所有widget，
		 * 需要默认局部禁用哪些功能，写在此接口中
		 * 
		 * @param enable:Boolean 状态true表示启用，false表示禁用。
		 */
		private function setPlayControls(enable:Boolean):void
		{
			//Debug.log("#############adType={}, adState={}, setPlayControls:{}", _global.ad.type, _global.ad.state, enable);
			if (scrubBar) scrubBar.enabled = enable; 
			if (togglePauseButton) 
			{
				if (_global.config.autoPlay) togglePauseButton.enabled = enable;
				else  togglePauseButton.enabled = true;
			}
			if (toggleStopButton) toggleStopButton.enabled = enable;
			if (rePlayButton) rePlayButton.enabled = enable;
			if (reConnectButton) reConnectButton.enabled = enable;
			if (videoTimeLabel) videoTimeLabel.enabled = enable;
			if (toggleClarityButton) toggleClarityButton.enabled = enable; 
			if (toggleQualityButton) toggleQualityButton.enabled = enable; 
			if (shareButton) shareButton.enabled = enable;
			//if (volumeWidget) volumeWidget.enabled = enable;
			if (recommendButton) recommendButton.enabled = enable;
			if (repeatButton) repeatButton.enabled=enable;
			if (settingsButton) settingsButton.enabled = enable;
			if (toggleWideScreenButton) toggleWideScreenButton.enabled = enable;
			if (picCommentButton) picCommentButton.enabled = enable;
			if (danmuButton) danmuButton.enabled = enable;
			
			// 特殊widget，设置此widget禁用时会同时设置它不可见
			if (rotationAndScale) rotationAndScale.enabled = enable;
			if (playListNextButton) playListNextButton.enabled=true;
			if (toggleLanguageButton) toggleLanguageButton.enabled = true;
			if (top_area) top_area.enabled=enable;
			if (right_area) right_area.enabled = enable;
			//Debug.log("#############volumeWidget.enabled={}, togglePauseButton.enabled={}", volumeWidget.enabled, togglePauseButton.enabled);
			//...
			
			//皮肤显示对应的音量
			if(_global.config) setVolume(_global.config.volume);
		}
		
		/**
		 * 设置总时长
		 *
		 * @param t:Number 视频总时长，以秒为单位。
		 */
		public function setTotalTime(time:Number):void
		{
			if (_total_time == time) return;
			_total_time = time;
			if (videoTimeLabel && videoTimeLabel.hasOwnProperty("totalTime")) videoTimeLabel["totalTime"] = _total_time;
			if (scrubBar && scrubBar.hasOwnProperty("totalTime")) scrubBar["totalTime"] = _total_time;
		}
		
		/**
		 * 设置播放时间
		 *
		 * @param t:Number 视频播放时间，以秒为单位。
		 */
		public function setPlayTime(time:Number):void
		{
			if (time > _total_time) time = _total_time;
			if (time < 0) time = 0;
			if (_playe_time != time)
			{
				_playe_time = time;
				var num:Number = (_total_time == 0 ) ? 0 : _playe_time / _total_time;
				if (videoTimeLabel && videoTimeLabel.hasOwnProperty("curTime")) videoTimeLabel["curTime"] = _playe_time;
				if (scrubBar && scrubBar.hasOwnProperty("playProgress")) scrubBar["playProgress"] = num ;
			}
		}
		
		/**
		 * 设置缓存进度（建议频率1/5秒一次）
		 * 
		 * @param loaded:Number 视频加载进度比率，0~1。
		 */
		private function setBuffer(loaded:Number):void
		{
			if (loaded<0 || loaded>1) return;
			if (_loaded != loaded)
			{
				_loaded = loaded;
				if (scrubBar && scrubBar.hasOwnProperty("loadProgress")) scrubBar["loadProgress"] = _loaded;
			}
		}
		
		/**
		 * 设置播放状态，用于更新播放按钮状态。
		 * 
		 * @param pause:Boolean 视频播放暂停状态，true表示暂停, false表示播放。
		 */
		public function setPause(pause:Boolean):void
		{
			_pause = pause;
			if (togglePauseButton && togglePauseButton.hasOwnProperty("pause")) togglePauseButton["pause"] = _pause;
			if (toggleStopButton && toggleStopButton.hasOwnProperty("stop")) toggleStopButton["stop"] = _pause;
			if (scrubBar && scrubBar.hasOwnProperty("pause")) scrubBar["pause"] = _pause;
			if (largeButton && largeButton.hasOwnProperty("pause")) largeButton["pause"] = _pause;
			
			if (rePlayButton && rePlayButton.visible == true)
			{
				rePlayButton.visible = false;
				rePlayButton.enabled = false;
				if (togglePauseButton)
				{
					togglePauseButton.visible = !rePlayButton.visible;
					togglePauseButton.enabled = !rePlayButton.enabled;
				}
			}
		}
		/**
		 * 操作提示信息
		 */
		private function setHintInfo():void
		{
			if (setInformation)
			{
				setHintMediator = SetHintMediator.getInstance();
				setHintMediator.init(setInformation);
			}
		}
		/**
		 * 设置视频重播状态，用于更新界面。
		 * 
		 * @param replay:Boolean 视频重播状态，true表示重播, false表示视频播放完成，隐藏切换暂停按钮并显示重播按钮。
		 */
		private function setReplay(replay:Boolean):void
		{
			if (rePlayButton)
			{
				rePlayButton.visible = !replay;
				rePlayButton.enabled = !replay;
				if (togglePauseButton)
				{
					togglePauseButton.visible = !rePlayButton.visible;
					togglePauseButton.enabled = !rePlayButton.enabled;
				}
			}
			
			if (replay == true)
			{
				setPause(false);
			}
			else {
				_pause = true;
			}
		}
		
		private function toggleHideShowSetPanel():void
		{
			if (setPanel)
			{
				setPanel.visible = !setPanel.visible;
				if (!setPanel.visible && setPanel.hasOwnProperty("cancel")) setPanel["cancel"]();
			}
		}
		private function HideShowhorcutKeysPanel(info:String):void
		{
			if (shorcutKeysPanel)
			{
				shorcutKeysPanel.visible = !shorcutKeysPanel.visible;
				if(shorcutKeysPanel.hasOwnProperty("showInfo")) shorcutKeysPanel["showInfo"](info);
			}
		}
		
		/**
		 * 视频流类型变化
		 * 
		 * @param	stream_type
		 */
		private function onStreamTypeChange(stream_type:String):void
		{
			switch(stream_type)
			{
				case StreamType.HTTP_DYNAMIC_STREAMING:
				case StreamType.HTTP_LIVE_STREAMING:
				case StreamType.LIVE:
				case StreamType.LIVE_OR_RECORDED:
				case StreamType.LIVE_OR_VOD:
				case StreamType.RTMP_STATIC_STREAMING:
					if (reConnectButton) reConnectButton.visible = true;
					break;
				default:
					if (reConnectButton) reConnectButton.visible = false;
					break;
			}
		}
		
		private function showSetPanel(show:Boolean, view:String=""):void
		{
			if (setPanel)
			{
				if (setPanel.visible == show) return;
				setPanel.visible = show;
				setPanel["view"] = view;
			}
		}
		
		private function setVolume(volume:Number):void
		{
			if (_global.ad&&_global.ad.isAdTime()) volume = _global.ad.volume;
			if (volumeWidget && volumeWidget.hasOwnProperty("volume")) volumeWidget["volume"] = volume;
		}
		
		private function setResolution(value:String):void
		{
			if (toggleClarityButton && toggleClarityButton.hasOwnProperty("clarity")) toggleClarityButton["clarity"] = value;
			if (toggleQualityButton && toggleQualityButton.hasOwnProperty("quality")) toggleQualityButton["quality"] = value;
		}
		
		private function setPanorama(value:int):void
		{
			if (!settingsButton) return;
			
			if (value > 0) settingsButton.style = "visible:false;";
			else settingsButton.style = "visible:true;";
			
			showSetPanel(false);
		}
		
		private function setMultiResolution(value:Array):void
		{
			if (value&&value.length > 1)
			{
				if (toggleClarityButton)
				{
					if(toggleClarityButton.hasOwnProperty("clarityArray")) toggleClarityButton["clarityArray"] = value;
					toggleClarityButton.visible = true;
				}
				if (toggleQualityButton)
				{
					if(toggleQualityButton.hasOwnProperty("qualityArray")) toggleQualityButton["qualityArray"] = value;
					toggleQualityButton.visible = true;
				}
			}
			else {
				if (toggleClarityButton) toggleClarityButton.visible = false;
				if (toggleQualityButton) toggleQualityButton.visible = false;
			}
		}
		
		private function setMultiResolutionRight(value:Object):void
		{
			if (toggleQualityButton)
			{
				if(toggleQualityButton.hasOwnProperty("qualityRight")) toggleQualityButton["qualityRight"] = value;
			}
			if (toggleClarityButton)
			{
				if(toggleClarityButton.hasOwnProperty("clarityRight")) toggleClarityButton["clarityRight"] = value;
			}
		}
		
		private function showInfo(info:String, autoHide:Boolean = true, autoHideTimeout:Number = 5000):void
		{
			if (informationWidget && informationWidget.hasOwnProperty("showInfo")) informationWidget["showInfo"](info, autoHide, autoHideTimeout);
		}
		
		private function showUserGuide(info:String, autoHide:Boolean = true, autoHideTimeout:Number = 5000):void
		{
			//mark:临时增加，事后再优化
			if (toggleQualityButton && toggleQualityButton.visible)
			{
				UserGuide.getInstance().show(toggleQualityButton, info, 25, 0, null, autoHide, "quality");
			}
		}
		
		private function showLoading(show:Boolean):void
		{
			if (bufferLoadWidget) bufferLoadWidget.visible = show;
		}
		
		private function showError(code:String, message:String):void
		{
			if (errorPanel && errorPanel.hasOwnProperty("showError")) errorPanel["showError"](code, message);
		}
		
		//
		private function setAllowFullScreenInteractive(value:Boolean):void
		{
			if(setPanel && setPanel.hasOwnProperty("allowFullScreenInteractive")) setPanel["allowFullScreenInteractive"] = value;
		}
		
		private function setColorMode(value:String):void
		{
			if(setPanel && setPanel.hasOwnProperty("mode")) setPanel["mode"] = value;
		}
		
		private function setBrightness(value:Number):void
		{
			if (setPanel && setPanel.hasOwnProperty("brightness")) setPanel["brightness"] = value;
			if(settingsButton && settingsButton.hasOwnProperty("brightness")) settingsButton["brightness"] = value;
		}
		
		private function setContrast(value:Number):void
		{
			if(setPanel && setPanel.hasOwnProperty("contrast")) setPanel["contrast"] = value;
		}
		
		private function setSaturation(value:Number):void
		{
			if(setPanel && setPanel.hasOwnProperty("saturation")) setPanel["saturation"] = value;
		}
		
		private function setProportionMode(value:String):void
		{
			if (setPanel && setPanel.hasOwnProperty("proportion")) setPanel["proportion"] = value;
			if(settingsButton && settingsButton.hasOwnProperty("proportion")) settingsButton["proportion"] = value;
		}
		
		private function setHardwareAccelerate(value:Boolean):void
		{
			if(setPanel && setPanel.hasOwnProperty("hardwareAccelerate")) setPanel["hardwareAccelerate"] = value;
		}
		
		private function setScale(value:Number):void
		{
			if (setPanel && setPanel.hasOwnProperty("scale")) setPanel["scale"] = value;
			if (toggleScaleWidget && toggleScaleWidget.hasOwnProperty("scale")) toggleScaleWidget["scale"] = value;
		}
		
		private function setRotationAngle(value:Number):void
		{
			if (setPanel && setPanel.hasOwnProperty("rotationAngle")) setPanel["rotationAngle"] = value;
			if(settingsButton && settingsButton.hasOwnProperty("rotationAngle")) settingsButton["rotationAngle"] = value;
		}
		
		/**
		 * @private
		 * 获取界面上的某个元素
		 */
		public function getElementById(name:String):DisplayObject
		{
			var element:DisplayObject;
			switch(name)
			{
				case "TopArea":
					element = top_area;
					break;
				case "BottomArea":
					element = bottom_area;
					break;
				case "LeftArea":
					element = left_area;
					break;
				case "RightArea":
					element = right_area;
					break;
				case "MiddleArea":
					element = middle_area;
					break;
			}
			if (element) return element;
			
			element = ElementsProvider.getInstance().widgetsManager.getWidget(name) as Sprite;
			
			return element;
		}
		
		/**
		 * @private
		 * 皮肤信息
		 */
		public function get info():Object
		{
			return _info;
		}
		
		
		//5区域容器
		private var top_area:TopArea;
		private var bottom_area:BottomArea;
		private var left_area:LeftArea;
		private var right_area:RightArea;
		private var middle_area:MiddleArea;
		
		//middle
		private var firstLoadWidget:Widget;
		private var bufferLoadWidget:Widget;
		private var setInformation:Widget;
		private var errorPanel:Widget;
		private var cloudPanel:Widget;
		private var privacyPanel:Widget;
		private var setPanel:Widget;
		private var shorcutKeysPanel:Widget;
		private var largeButton:Widget;
		private var playList:Widget;
		private var paidTimeoutPanel:Widget;
		
		//left
		//...
		
		//right
		private var rightAreaShareButton:Widget;
		private var toggleOffLightButton:Widget;
		private var rightAreaCommentButton:Widget;
		private var rightAreaDanmuButton:Widget;
		private var rightAreaCloudButton:Widget;
		
		//top
		private var videoTitleLabel:Widget;
		private var toggleScaleWidget:Widget;
		private var searchWidget:Widget;
		private var localTime:Widget;
		private var playListButton:Widget;
		private var exitFullScreenButton:Widget;
		private var rotationAndScale:Widget;
		
		//bottom
		private var informationWidget:Widget;
		private var scrubBar:Widget;
		private var togglePauseButton:Widget;
		private var toggleStopButton:Widget;
		private var rePlayButton:Widget;
		private var reConnectButton:Widget;
		private var playListNextButton:Widget;
		private var videoTimeLabel:Widget;
		private var shareButton:Widget;
		private var volumeWidget:Widget;
		private var demandListButton:Widget;
		private var toggleLanguageButton:Widget;
		private var toggleClarityButton:Widget;
		private var toggleQualityButton:Widget;
		private var repeatButton:Widget;
		private var settingsButton:Widget;
		private var danmuButton:Widget;
		private var recommendButton:Widget;
		private var picCommentButton:Widget;
		private var toggleWideScreenButton:Widget;
		private var toggleFullScreenButton:Widget;
		
		private var _playe_time:Number = 0.0;
		private var _total_time:Number = 0.0;
		private var _loaded:Number = 0.0;
		private var _pause:Boolean = false;
		private var _size_mode:String = SizeMode.NORMAL;
		private var _info:Object = { };
		
		private var elements_provider:ElementsProvider;
		private var skin_config:XML;
		private var skin_mask:Shape;
		
		private var setHintMediator:SetHintMediator;
		
		private const DEFAULT_FRAME_RATE:int = 25;
		private const NAME:String = "Tudou media player skin.";
		private var default_style:String = "position:stage; width:100%; height:100%;";
		
	}
	
}