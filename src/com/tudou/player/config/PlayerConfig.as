package com.tudou.player.config 
{
	//import com.tudou.player.log.PlayerLog;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	/**
	 * 播放器功能配置信息
	 * - TODO:
		 * 封装播放功能相关信息、参数配置 并提供默认值
		 * 当有元素变化时 抛出事件
		 * 当有元素异常时 抛出异常
	* - NOTE:
		 * 初始化时虽然会抛出属性变化事件，但是播放器并没初始化完成，不会受影响
		 * 如需抛出更改之前的属性值，需要将事件改为先发 并带上老属性值和设置的value.
	 * @author 8088 at 2014/6/23 14:56:27
	 */
	public class PlayerConfig extends BaseInfo
	{
		
		public function PlayerConfig() 
		{
			initialize();
		}
		
		/**
		 * 初始化各配置为默认值
		 */
		public function initialize():void
		{
			_playerId = "custom";
			_productId = "tudou";
			_uniqueId = BaseInfo.createRandomId();
			_playerVersion = "3.0.0";
			_coreId = null;
			_skin = null;
			
			_rightMenu = null;
			_shortKey = null;
			_watermark = null;
			
			_autoPlay = true;
			_loopPlay = false;
			_volume = 1;
			_bufferTime = 1;
			_loadMode = LoadMode.TCP;
			
			_hasDanmu = false;
			_openDanmu = false;
			_hasWatermark = false;
			_autoHideControlBar = false;
			_controlBarHeight = 0.0;
			
			_allowSharedObjectRecord = true;
			_allowPlayControls = false;
			_allowFullScreenInteractive = false;
			_allowHardwareAccelerateSet = true;
			_hardwareAccelerate = false;
			_allowColorSet = true;
			_colorMode = ColorMode.CUSTOM;
			_brightness = 0.5;
			_contrast = 0.5;
			_saturation = 0.5;
			_proportionMode = "original";
			_allowProportionSet = true;
			_scale = 1;
			_allowScaleSet = true;
			_rotationAngle = 0;
			_allowRotationSet = true;
			
			_preferredQuality = "auto";
		}
		
		/**
		 * 播放器产品唯一标识
		 * - 标识是什么播放器
		 * - 插件按播放产品配置都有什么插件
		 * - 各播放产品所处理的业务也各有不同
		 */
		public function get playerId():String
		{
			return _playerId;
		}
		public function set playerId(value:String):void
		{
			if (_playerId != value)
			{
				_playerId = value;
				
				dispatchPropertyChangeEvent("playerId");
			}
		}
		
		/**
		 * 客户产品唯一标识
		 * - 标识使用播放器的客户
		 * - 水印模块根据此标示显示对应的水印
		 * - 标识对外合作的第三方使用ID
		 */
		public function get productId():String
		{
			return _productId;
		}
		public function set productId(value:String):void
		{
			if (_productId != value)
			{
				_productId = value;
				
				dispatchPropertyChangeEvent("productId");
			}
		}
		
		/**
		 * 播放器运行时唯一标识(只读)
		 */
		public function get uniqueId():String
		{
			return _uniqueId;
		}
		
		/**
		 * 播放器版本
		 */
		public function get playerVersion():String
		{
			return _playerVersion;
		}
		public function set playerVersion(value:String):void
		{
			if (_playerVersion != value)
			{
				_playerVersion = value;
				
				dispatchPropertyChangeEvent("playerVersion");
			}
		}
		
		/**
		 * 核心标识
		 * - 当前播放核心的唯一标识,已支持的核心：daybreak、dayspring、auroral、cirrus、rtmp、cloud；
		 */
		public function get coreId():String
		{
			return _coreId;
		}
		public function set coreId(value:String):void
		{
			if (_coreId != value)
			{
				_coreId = value;
				
				dispatchPropertyChangeEvent("coreId");
			}
		}
		
		/**
		 * 皮肤标识
		 */
		public function get skin():String
		{
			return _skin;
		}
		public function set skin(value:String):void
		{
			if (_skin != value)
			{
				_skin = value;
				
				dispatchPropertyChangeEvent("skin");
			}
		}
		/**
		 * 右键菜单标识
		 */
		public function get rightMenu():String
		{
			return _rightMenu;
		}
		public function set rightMenu(value:String):void
		{
			if (_rightMenu != value)
			{
				_rightMenu = value;
				
				dispatchPropertyChangeEvent("rightMenu");
			}
		}
		
		/**
		 * 快捷键标识
		 */
		public function get shortKey():String
		{
			return _shortKey;
		}
		public function set shortKey(value:String):void
		{
			if (_shortKey != value)
			{
				_shortKey = value;
				dispatchPropertyChangeEvent("shortKey");
			}
		}
		
		/**
		 * 水印标识
		 */
		public function get watermark():String
		{
			return _watermark;
		}
		public function set watermark(value:String):void
		{
			if (_watermark != value)
			{
				_watermark = value;
				
				dispatchPropertyChangeEvent("watermark");
			}
		}
		
		/**
		 * 标识产品水印
		 */
		public function get watermarkProduct():String
		{
			return _watermarkProduct;
		}
		public function set watermarkProduct(value:String):void
		{
			if (_watermarkProduct != value)
			{
				_watermarkProduct = value;
				
				dispatchPropertyChangeEvent("watermarkProduct");
			}
		}
		
		/**
		 * 是否自动播放
		 */
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}
		public function set autoPlay(value:Boolean):void
		{
			if (_autoPlay != value)
			{
				_autoPlay = value;
				
				dispatchPropertyChangeEvent("autoPlay");
			}
		}
		
		/**
		 * 是否循环播放
		 */
		public function get loopPlay():Boolean
		{
			return _loopPlay;
		}
		public function set loopPlay(value:Boolean):void
		{
			if (_loopPlay != value)
			{
				_loopPlay = value;
				
				dispatchPropertyChangeEvent("loopPlay");
			}
		}
		
		/**
		 * 音量配置
		 * - 正常值范围：0～1
		 * - 快捷键可持续增大，并控制音量范围：0～5
		 */
		public function get volume():Number
		{
			return _volume;
		}
		public function set volume(value:Number):void
		{
			if ( isNaN(value)) return;
			if (value < 0) value = 0;
			if (value > 5) value = 5;
			
			if (_volume != value)
			{
				_volume = value;
				
				dispatchPropertyChangeEvent("volume");
			}
		}
		/*
		public function get muffleFactor():Number
        {
            var n:Number = NaN;
            if (!loudness)
            {
                return DEFAULT_MUFFLE;
            }
            n = Math.min(LOUDNESS_TARGET_DECIBELS - loudness, 10);
            return Math.pow(10, n / 20);
        }
		*/
		/**
		 * 缓冲时长配置
		 * - 单位：秒
		 */
		public function get bufferTime():Number
		{
			return _bufferTime;
		}
		public function set bufferTime(value:Number):void
		{
			if (_bufferTime != value)
			{
				_bufferTime = value;
				
				dispatchPropertyChangeEvent("bufferTime");
			}
		}
		
		/**
		 * 加载形式
		 * - 支持TCP(http、socket) 和 UDP。
		 */
		public function get loadMode():String
		{
			return _loadMode;
		}
		public function set loadMode(value:String):void
		{
			if (_loadMode != value)
			{
				_loadMode = value;
				
				dispatchPropertyChangeEvent("loadMode");
			}
		}
		
		/**
		 * 允许共享对象记录
		 */
		public function get allowSharedObjectRecord():Boolean
		{
			return _allowSharedObjectRecord;
		}
		
		public function set allowSharedObjectRecord(value:Boolean):void
		{
			if (_allowSharedObjectRecord != value)
			{
				_allowSharedObjectRecord = value;
				
				dispatchPropertyChangeEvent("allowSharedObjectRecord");
			}
		}
		
		/**
		 * 允许播放控制
		 */
		public function get allowPlayControls():Boolean
		{
			return _allowPlayControls;
		}
		
		public function set allowPlayControls(value:Boolean):void
		{
			if (_allowPlayControls != value)
			{
				_allowPlayControls = value;
				
				dispatchPropertyChangeEvent("allowPlayControls");
			}
		}
		
		/**
		 * 允许可交互的全屏
		 */
		public function get allowFullScreenInteractive():Boolean
		{
			return _allowFullScreenInteractive;
		}
		
		public function set allowFullScreenInteractive(value:Boolean):void
		{
			if (_allowFullScreenInteractive != value)
			{
				_allowFullScreenInteractive = value;
				
				dispatchPropertyChangeEvent("allowFullScreenInteractive");
			}
		}
		
		/**
		 * 允许硬件加速设置
		 */
		public function get allowHardwareAccelerateSet():Boolean
		{
			return _allowHardwareAccelerateSet;
		}
		public function set allowHardwareAccelerateSet(value:Boolean):void
		{
			if (_allowHardwareAccelerateSet != value)
			{
				_allowHardwareAccelerateSet = value;
				
				dispatchPropertyChangeEvent("allowHardwareAccelerateSet");
			}
		}
		
		/**
		 * 硬件加速
		 */
		public function get hardwareAccelerate():Boolean
		{
			return _hardwareAccelerate;
		}
		public function set hardwareAccelerate(value:Boolean):void
		{
			if (_hardwareAccelerate != value)
			{
				_hardwareAccelerate = value;
				
				dispatchPropertyChangeEvent("hardwareAccelerate");
			}
		}
		
		/**
		 * 允许色彩设置
		 */
		public function get allowColorSet():Boolean
		{
			return _allowColorSet;
		}
		public function set allowColorSet(value:Boolean):void
		{
			if (_allowColorSet != value)
			{
				_allowColorSet = value;
				
				dispatchPropertyChangeEvent("allowColorSet");
			}
		}
		
		/**
		 * 色彩模式
		 * - 已支持定制、明亮、生动、剧院
		 */
		public function get colorMode():String
		{
			return _colorMode;
		}
		public function set colorMode(value:String):void
		{
			if (_colorMode != value)
			{
				if (ColorMode.isSupport(value))
				{
					_colorMode = value;
				
					dispatchPropertyChangeEvent("colorMode");
				}
				else {
					//PlayerLog.getInstance().debug("Sorry! Color mode '"+value+"' is not support！");
				}
			}
		}
		
		/**
		 * 亮度
		 */
		public function get brightness():Number
		{
			return _brightness;
		}
		public function set brightness(value:Number):void
		{
			if (_brightness != value)
			{
				
				if (value < 0) value = 0;
				if (value > 1) value = 1;
				
				_brightness = value;
				
				dispatchPropertyChangeEvent("brightness");
			}
		}
		
		/**
		 * 对比度
		 */
		public function get contrast():Number
		{
			return _contrast;
		}
		public function set contrast(value:Number):void
		{
			if (_contrast != value)
			{
				
				if (value < 0) value = 0;
				if (value > 1) value = 1;
				
				_contrast = value;
				
				dispatchPropertyChangeEvent("contrast");
			}
		}
		
		/**
		 * 饱和度
		 */
		public function get saturation():Number
		{
			return _saturation;
		}
		public function set saturation(value:Number):void
		{
			if (_saturation != value)
			{
				
				if (value < 0) value = 0;
				if (value > 1) value = 1;
				
				_saturation = value;
				
				dispatchPropertyChangeEvent("saturation");
			}
		}
		
		/**
		 * 比例模式
		 */
		public function get proportionMode():String
		{
			return _proportionMode;
		}
		public function set proportionMode(value:String):void
		{
			if (_proportionMode != value)
			{
				if (ProportionMode.isSupport(value))
				{
					_proportionMode = value;
					
					dispatchPropertyChangeEvent("proportionMode");
				}
				else {
					//PlayerLog.getInstance().debug("Sorry! Proportion mode '"+value+"' is not support！");
				}
			}
		}
		
		/**
		 * 允许比例设置
		 */
		public function get allowProportionSet():Boolean
		{
			return _allowProportionSet;
		}
		public function set allowProportionSet(value:Boolean):void
		{
			if (_allowProportionSet != value)
			{
				_allowProportionSet = value;
				
				dispatchPropertyChangeEvent("allowProportionSet");
			}
		}
		
		/**
		 * 缩放
		 */
		public function get scale():Number
		{
			return _scale;
		}
		public function set scale(value:Number):void
		{
			if (_scale != value)
			{
				_scale = value;
				
				dispatchPropertyChangeEvent("scale");
			}
		}
		
		/**
		 * 允许缩放设置
		 */
		public function get allowScaleSet():Boolean
		{
			return _allowScaleSet;
		}
		public function set allowScaleSet(value:Boolean):void
		{
			if (_allowScaleSet != value)
			{
				_allowScaleSet = value;
				
				dispatchPropertyChangeEvent("allowScaleSet");
			}
		}
		
		/**
		 * 旋转
		 */
		public function get rotationAngle():Number
		{
			return _rotationAngle;
		}
		public function set rotationAngle(value:Number):void
		{
			if (_rotationAngle != value)
			{
				if (value % 90 == 0)
				{
					if (value >= 360) value = value % 360;
					if (value <= -360) value = value % -360;
				
					_rotationAngle = value;
					
					dispatchPropertyChangeEvent("rotationAngle");
				}
				else {
					//PlayerLog.getInstance().debug("Sorry! Rotation angle '"+value+"' is not support！");
				}
			}
		}
		
		/**
		 * 允许旋转设置
		 */
		public function get allowRotationSet():Boolean
		{
			return _allowRotationSet;
		}
		public function set allowRotationSet(value:Boolean):void
		{
			if (_allowRotationSet != value)
			{
				_allowRotationSet = value;
				
				dispatchPropertyChangeEvent("allowRotationSet");
			}
		}
		
		/**
		 * 是否有弹幕功能
		 */
		public function get hasDanmu():Boolean
		{
			return _hasDanmu;
		}
		public function set hasDanmu(value:Boolean):void
		{
			if (_hasDanmu != value)
			{
				_hasDanmu = value;
				
				dispatchPropertyChangeEvent("hasDanmu");
			}
		}
		
		/**
		 * 是否开启弹幕功能
		 */
		public function get openDanmu():Boolean
		{
			return _openDanmu;
		}
		public function set openDanmu(value:Boolean):void
		{
			if (_openDanmu != value)
			{
				_openDanmu = value;
				
				dispatchPropertyChangeEvent("openDanmu");
			}
		}
		
		/**
		 * 是否有水印
		 */
		public function get hasWatermark():Boolean
		{
			return _hasWatermark;
		}
		public function set hasWatermark(value:Boolean):void
		{
			if (_hasWatermark != value)
			{
				_hasWatermark = value;
				
				dispatchPropertyChangeEvent("hasWatermark");
			}
		}
		
		/**
		 * 是否自动隐藏播放器控制条
		 */
		public function get autoHideControlBar():Boolean
		{
			return _autoHideControlBar;
		}
		public function set autoHideControlBar(value:Boolean):void
		{
			if (_autoHideControlBar != value)
			{
				_autoHideControlBar = value;
				
				dispatchPropertyChangeEvent("autoHideControlBar");
			}
		}
		
		/**
		 * @private
		 * 皮肤控制条的高度
		 */
		public function get controlBarHeight():Number
		{
			return _controlBarHeight;
		}
		public function set controlBarHeight(value:Number):void
		{
			if (_controlBarHeight != value)
			{
				_controlBarHeight = value;
				
				dispatchPropertyChangeEvent("controlBarHeight");
			}
		}
		
		/**
		 * 首选清晰度
		 */
		public function get preferredQuality():String
		{
			return _preferredQuality;
		}
		public function set preferredQuality(value:String):void
		{
			if (_preferredQuality != value)
			{
				_preferredQuality = value;
				
				dispatchPropertyChangeEvent("preferredQuality");
			}
		}
		
		override public function toObject():Object
		{
			var _obj:Object = {
				playerId:_playerId,
				productId:_productId,
				uniqueId:_uniqueId,
				playerVersion:_playerVersion,
				coreId:_coreId,
				skin:_skin,
				rightMenu:_rightMenu,
				watermark:_watermark,
				watermarkProduct:_watermarkProduct,
				
				autoPlay:_autoPlay,
				loopPlay:_loopPlay,
				volume:_volume,
				bufferTime:_bufferTime,
				
				hasDanmu:_hasDanmu,
				openDanmu:_openDanmu,
				hasWatermark:_hasWatermark,
				autoHideControlBar:_autoHideControlBar,
				controlBarHeight:_controlBarHeight,
				loadMode:_loadMode,
				
				allowSharedObjectRecord:_allowSharedObjectRecord,
				allowPlayControls:_allowPlayControls,
				allowFullScreenInteractive:_allowFullScreenInteractive,
				allowHardwareAccelerateSet:_allowHardwareAccelerateSet,
				hardwareAccelerate:_hardwareAccelerate,
				
				allowColorSet:_allowColorSet,
				colorMode:_colorMode,
				brightness:_brightness,
				contrast:_contrast,
				saturation:_saturation,
				
				allowProportionSet:_allowProportionSet,
				proportionMode:_proportionMode,
				allowScaleSet:_allowScaleSet,
				scale:_scale,
				allowRotationSet:_allowRotationSet,
				rotationAngle:_rotationAngle,
				
				preferredQuality:_preferredQuality
			};
			return _obj;
		}
		
		
		private var _playerId:String;
		private var _productId:String;
		private var _uniqueId:String;
		private var _playerVersion:String;
		private var _coreId:String;
		private var _skin:String;
		private var _rightMenu:String;
		private var _shortKey:String;
		private var _watermark:String;
		private var _watermarkProduct:String;
		
		private var _autoPlay:Boolean;
		private var _loopPlay:Boolean;
		private var _volume:Number;
		private var _bufferTime:Number;
		
		private var _hasDanmu:Boolean;
		private var _openDanmu:Boolean;
		private var _hasWatermark:Boolean;
		private var _autoHideControlBar:Boolean;
		private var _controlBarHeight:Number;
		private var _loadMode:String;
		
		private var _allowSharedObjectRecord:Boolean;
		private var _allowPlayControls:Boolean;
		private var _allowFullScreenInteractive:Boolean;
		private var _allowHardwareAccelerateSet:Boolean;
		private var _hardwareAccelerate:Boolean;
		//颜色
		private var _allowColorSet:Boolean;
		private var _colorMode:String;
		private var _brightness:Number;
		private var _contrast:Number;
		private var _saturation:Number;
		//画面
		private var _allowProportionSet:Boolean;
		private var _proportionMode:String;
		private var _allowScaleSet:Boolean;
		private var _scale:Number;
		private var _allowRotationSet:Boolean;
		private var _rotationAngle:Number;
		
		//首选清晰度
		private var _preferredQuality:String;
		
		public static const DEFAULT_MUFFLE:Number = 1;
		public static const LOUDNESS_TARGET_DECIBELS:Number = -21;
	}

}