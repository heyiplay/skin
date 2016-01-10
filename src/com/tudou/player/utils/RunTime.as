package com.tudou.player.utils 
{
	import flash.errors.IllegalOperationError;
	/**
	 * 运行时序
	 * - 记录程序运转的时序
	 * 
	 * @author 8088 at 2014/7/4 20:59:45
	 */
	public class RunTime extends Object
	{
		
		public function RunTime(lock:Class = null) 
		{
			if (lock != ConstructorLock)
			{
				throw new IllegalOperationError("禁止实例化 PlayerState !");
			}
		}
		
		public static function getInstance():RunTime
		{
			_instance ||= new RunTime(ConstructorLock);
			return _instance;
		}
		
		public function getDescByStep(key:int):String
		{
			if (key >= _step_desc.length) return "undefind";
			
			return _step_desc[key];
		}
		
		public function get step():int
		{
			return _step;
		}
		
		public function set step(value:int):void
		{
			_step = value;
		}
		
		
		// Internals..
		//
		
		private static var _instance:RunTime;
		
		private var _step:int;
		
		private var _step_desc:Array =
		[
			"First Loading",
			"Init FlashVars",
			"Init Stage",
			"Init ShareObject Config",
			"Init Core",
			"Init Ad",
			"Init Skin",
			"Init App",
			"Init Right Menu",
			"Init Shortcut Keys",
			"Init API",
			"Player Is Ready",
		]
	}

}

class ConstructorLock {};