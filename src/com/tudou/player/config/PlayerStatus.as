package com.tudou.player.config 
{
	import com.tudou.utils.Debug;
	import com.tudou.utils.URL;
	import com.tudou.utils.Utils;
	import flash.display.StageDisplayState;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.system.System;
	/**
	 * 播放器（运行时）的状态信息
	 * 
	 * @author 8088 at 2014/8/2 17:31:23
	 */
	public class PlayerStatus extends BaseInfo
	{
		
		public function PlayerStatus(lock:Class = null) 
		{
			if (lock != ConstructorLock)
			{
				throw new IllegalOperationError("禁止实例化 PlayerStatus !");
			}
			
			initialize();
		}
		
		public static function getInstance():PlayerStatus
		{
			_instance ||= new PlayerStatus(ConstructorLock);
			return _instance;
		}
		
		/**
		 * 初始化各参数为默认值
		 */
		public function initialize():void
		{
			//初始化各参数
			_displayState = StageDisplayState.NORMAL;
			
			//...
			
		}
		
		/**
		 * 显示状态
		 */
		public function get displayState():String
		{
			return _displayState;
		}
		
		public function set displayState(value:String):void
		{
			if (value && _displayState != value)
			{
				_displayState = value;
				
				dispatchPropertyChangeEvent("displayState");
			}
		}
		
		/**
		 * 屏幕变化中
		 */
		public function get screenChanging():Boolean
		{
			return _screenChanging;
		}
		
		public function set screenChanging(value:Boolean):void
		{
			if (_screenChanging != value)
			{
				_screenChanging = value;
				
				dispatchPropertyChangeEvent("screenChanging");
			}
		}
		
        public function isFullScreen():Boolean
        {
            return this.displayState == StageDisplayState.FULL_SCREEN || this.displayState == "fullScreenInteractive";
        }
		
		override public function toObject():Object
		{
			var _obj:Object = {
				displayState:_displayState
			};
			return _obj;
		}
		
		
		// Internals..
		//
		
		
		private static var _instance:PlayerStatus;
		
		private var _displayState:String;
		private var _screenChanging:Boolean;
		
	}

}
class ConstructorLock {};