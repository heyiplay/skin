package com.tudou.player.config 
{
	/**
	 * 媒体类型
	 * 
	 * @author 8088
	 */
	public class ProportionMode 
	{
		/**
		 * 原比例
		 */
		public static const ORIGINAL:String = "original";
		
		/**
		 * 4:3
		 */
		public static const FOUR_THREE:String = "4:3";
		
		/**
		 * 16:9
		 */
		public static const SIXTEEN_NINE:String = "16:9";
		
		
		public static function isSupport(value:String):Boolean
		{
			if (value == ORIGINAL
			|| value == FOUR_THREE
			|| value == SIXTEEN_NINE
			)
			{
				return true;
			}
			else return false;
		}
	}

}