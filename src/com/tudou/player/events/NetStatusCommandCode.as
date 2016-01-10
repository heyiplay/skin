package com.tudou.player.events
{

	/**
	 * 命令代码
	 */
	public class NetStatusCommandCode
	{
		/**
		 * 参数信息设置
		 */
		public static const SET_PLAY_DATA:String = "setPlayData";
		
		public static const SET_MEDIA_INFO:String = "setMediaInfo";
		
		public static const SET_USER_INFO:String = "setUserInfo";
		
		public static const SET_PLAYER_CONFIG:String = "setPlayerConfig";
		
		/*
		 * 播放控制
		 */
		public static const PLAY:String = "play";
		
		public static const PAUSE:String="pause";
		
		public static const RESUME:String="resume";
		
		public static const SEEK:String = "seek";
		
		public static const REPLAY:String = "replay";
		
		public static const RECONNECT:String = "reconnect";
		
		public static const START:String = "start";
		
		public static const RESTART:String = "restart";
		
		public static const STOP:String="stop";
		
		/*
		 * 设置音量
		 * event.level:音量。设置范围 0~5，大于1的音量可通过快捷键设置
		 */
		public static const SET_VOLUME:String = "setVolume";
		
		public static const VOLUME_UP:String = "volumeUp";
		
		public static const VOLUME_DOWN:String = "volumeDown";
		
		/*
		 * 切换清晰度
		 */
		public static const SET_QUALITY:String = "setQuality";
		
		public static const CHANGE_QUALITY:String = "changeQuality";
		
		public static const SET_PREFERRED_QUALITY:String = "setPreferredQuality";
		
		/*
		 * 设置视频语言版本
		 * event.level: 国语、英语、法语...
		 */
		public static const SET_LANGUAGE:String = "setLanguage";
		
		public static const PLAY_LIST:String="playList";
		
		public static const GOTO_MAINSITE:String="gotoMainsite";
		
		public static const REGISTER:String = "register";
		
		public static const LOGIN:String = "login";
		
		public static const LOGOUT:String = "logout";
		
		public static const PLAY_NEXT:String = "playNext";
		
		/*
		 * 设置 播放器/视频 尺寸、比例、旋转
		 */
		public static const SET_PLAYER_SIZE:String = "setPlayerSize";
		
		public static const SET_PLAYER_SIZE_NORMAL:String = "setPlayerSizeNormal";
		
		public static const SET_PLAYER_SIZE_FULLSCREEN:String = "setPlayerSizeFullScreen";
		
		public static const SET_PLAYER_SIZE_NARROWSCREEN:String = "setPlayerSizeNarrowScreen";
		
		public static const SET_PLAYER_SIZE_WIDECREEN:String = "setPlayerSizeWideScreen";
		
		public static const SET_PLAYER_SIZE_POPUP:String = "setPlayerSizePopUp";
		
		public static const SET_SCALE:String = "setScale";
		
		public static const SET_SIZE:String = "setSize";
		
		public static const SET_PROPORTION_MODE:String = "setProportionMode";
		
		public static const SET_ROTATION_ANGLE:String = "setRotationAngle";
		
		public static const SET_ROTATION_LEFT:String = "setRotationLeft";
		
		public static const SET_ROTATION_RIGHT:String = "setRotationRight";
		
		public static const SET_FILP:String = "setFilp";
		
		public static const SET_PLAYER_STYLE:String = "setPlayerStyle";
		
		public static const SET_PLAYER_TWEEN_TO_STYLE:String = "setPlayerTweenToStyle";
		
		public static const TOGGLE_FULLSCREEN:String = "toggle_fullscreen";
		
		/*
		 * 设置面板 参数发生变化
		 */
		public static const SET_PANEL_RARAMS_CHANGED:String = "setPanelParamsChanged"
		/*
		 * 显示、隐藏、载入各种面板
		 */
		public static const SHOW_SET_PANEL:String = "showSetPanel";
		
		public static const HIDE_SET_PANEL:String = "hideSetPanel";
		
		public static const TOGGLE_HIDE_SHOW_SET_PANEL:String = "toggleHideShowSetPanel";
		
		public static const SHOW_SHARE_PANEL:String = "showSharePanel";
		
		public static const HIDE_SHARE_PANEL:String = "hideSharePanel";
		
		public static const SHOW_INFO_PANEL:String="showInfoPanel";
		
		public static const HIDE_INFO_PANEL:String = "hideInfoPanel";
		
		public static const SHOW_CLOUD_PANEL:String = "showCloudPanel";
		
		public static const HIDE_CLOUD_PANEL:String = "hideCloudPanel";
		
		public static const SHOW_RECOMMEND_PANEL:String = "showRecommendPanel";
		
		public static const HIDE_RECOMMEND_PANEL:String = "hideRecommendPanel";
		
		public static const HIDE_SHOW_SHORCUTKEYS_PANEL:String = "showShorcutKeys";
		
		/*
		 * 搜索
		 *
		 */
		public static const SEARCH:String="search";
		/*
		 * 去土豆网观看
		 *
		 */
		public static const GOTO_TUDOU_PLAY:String="gotoTudouPlay";
		/*
		 * 去土豆网评论
		 *
		 */
		public static const GOTO_TUDOU_COMMENT:String="gotoTudouComment";
		/*
		 * 开灯/关灯
		 *
		 */
		public static const ON_LIGHT:String = "onLight";
		
		public static const OFF_LIGHT:String = "offLight";
		
		/*
		 * 设置
		 *
		 */
		public static const SET_COLOR_MODE:String = "setColorMode";
		
		public static const SET_COLOR_BRIGHTNESS:String = "setColorBrightness";
		
		public static const SET_COLOR_CONTRAST:String = "setColorContrast";
		
		public static const SET_COLOR_SATURATION:String="setColorSaturation";
		
		//================================= 播放设置 ==================================
		
		/*
		 * 设置跳过片头片尾
		 *
		 */
		public static const SET_SKIP_HEAD_AND_TAIL:String = "setSkipHeadAndTail";
		
		public static const SET_SKIP_HEAD:String = "setSkipHead";
		
		public static const SET_SKIP_TAIL:String = "setSkipTail";
		
		public static const SET_ALLOW_FULL_SCREEN_INTERACTIVE:String = "setAllowFullScreenInteractive";
		
		
		/*
		 * 设置硬件加速
		 *
		 */
		public static const SET_HARDWARE_ACCELERATE:String="setHardwareAccelerate";
		
		
		//================================= 其他设置 ==================================

		/*
		 * 设置是否连续播放
		 *
		 */
		public static const SET_AUTO_CONTINUOUS_PLAY:String="setAutoContinuousPlay";
		/*
		 * 设置是否根据带宽情况自动切换清晰度
		 *
		 */
		public static const SET_AUTO_CLARITY:String="setAutoClarity";
		/*
		 * 显示、隐藏播放列表
		 *
		 */
		public static const SHOW_PLAY_LIST:String = "showPlayList";
		
		public static const HIDE_PLAY_LIST:String="hidePlayList";
		/*
		* 弹幕 打开 关闭
		*/
		public static const OPEN_DANMU:String = "openDanmu";
		
		public static const CLOSE_DANMU:String = "closeDanmu";
		
		public static const SUBMIT_DANMU:String = "submitDanmu";
		
		public static const OPEN_PICCOMMENT:String = "openPicComment";
		
		public static const CLOSE_PICCOMMENT:String = "closePicComment";
		
		/**
		 * 记录到Cookie
		 */
		public static const RECORD_TO_FLASH_COOKIE:String = "recordFlashCookie";
		
		public static const RECORD_TO_JS_COOKIE:String = "recordJsCookie";
		
	}

}

