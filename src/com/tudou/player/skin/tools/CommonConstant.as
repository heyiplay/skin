package com.tudou.player.skin.tools 
{
	/**
	 * ...
	 * @author likui
	 */
	public class CommonConstant 
	{
		public static const AUDIO_TYPE:String = "au"; //音频
		
		//audioPicPath
        public static const AUDIO_PIC:String = "http://js.tudouui.com/bin/lingtong/audio_pic_1.png";
		
		//stream rate definition: from flashVars and will mapping to be the video type to get url from v2
        public static const RATE_AUTO:int = -1;
		public static const RATE_P256:int = 0;
        public static const RATE_P360:int = 1;
        public static const RATE_P480:int = 2;
        public static const RATE_P720:int = 3;
		public static const RATE_P1080:int = 4;
        
        public static const ORIGINAL:int = 99;
		
		
		
		  //Rate Display
        public static const DISPLAY_SMOOTH_VIDEO:String = "流畅"; //256P
        public static const DISPLAY_HD_VIDEO:String = "高清"; //360P
        public static const DISPLAY_ULTRA_CLEAR_VIDEO:String = "超清"; //480P, 720P
		public static const DISPLAY_SUPER_VIDEO:String = "1080P";
        public static const DISPLAY_ORIGINAL_VIDEO:String = "原画"; //Original(99)
		public static const DISPLAY_AUTO:String = "自动";
        ///////////////////////////  Rate Page Const <End> /////////////////////////////////
	}

}