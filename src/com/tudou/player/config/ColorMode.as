package com.tudou.player.config 
{
	/**
	 * 媒体类型
	 * 
	 * @author 8088
	 */
	public class ColorMode 
	{
		/**
		 * 定制
		 */
		public static const CUSTOM:String = "custom";
		
		/**
		 * 明亮
		 */
		public static const BRIGHT:String = "bright";
		
		/**
		 * 生动
		 */
		public static const VIVID:String = "vivid";
		
		/**
		 * 剧院
		 */
		public static const THEATRE:String = "theatre";
		
		public static function isSupport(value:String):Boolean
		{
			if (value == CUSTOM
			|| value == BRIGHT
			|| value == VIVID
			|| value == THEATRE
			)
			{
				return true;
			}
			else return false;
		}
	}

}