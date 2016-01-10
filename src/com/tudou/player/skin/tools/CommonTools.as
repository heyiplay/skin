package com.tudou.player.skin.tools 
{
	/**
	 * ...
	 * @author likui
	 */
	public class CommonTools 
	{
		
		 /**
         * Generate video clarity display array for SKIN. 
         * [Note] Skin will use the same sequence to show them. 
         * 
         * @param maxRate          From FlashVar. Max rate except original.
         * @param hasOriginal      From FlashVar. If this video has original.
         */        
        public static function generateClarityDisplayArr(maxRate:int, hasOriginal:Boolean, is1080P:Boolean ):Array
        {
            var result:Array = [];
            maxRate = convertToLegalMaxRate(maxRate);
            
            switch (maxRate)
            {
                case CommonConstant.RATE_P720:
                case CommonConstant.RATE_P480:
                    result.unshift(CommonConstant.DISPLAY_ULTRA_CLEAR_VIDEO);
                case CommonConstant.RATE_P360:
                    result.unshift(CommonConstant.DISPLAY_HD_VIDEO);
                case CommonConstant.RATE_P256:
                    result.unshift(CommonConstant.DISPLAY_SMOOTH_VIDEO);
                    break;
            }
            
			if (is1080P)
			{
				result.push(CommonConstant.DISPLAY_SUPER_VIDEO);
			}
            if (hasOriginal)
                result.push(CommonConstant.DISPLAY_ORIGINAL_VIDEO);
            
            return result;
        }
		
		
		 /**
         * 得到合法的除原画外的最大码流。如果rate参数为-1，则视为最大无限制，将返回除原画外的最大码流 
         */        
        private static function convertToLegalMaxRate(rate:int):int
        {
            if (rate == -1)
                return CommonConstant.RATE_P720;
            
            if (CommonConstant.RATE_P256 > rate)
                rate = CommonConstant.RATE_P256;
            else if (CommonConstant.RATE_P720 < rate)
                rate = CommonConstant.RATE_P720;
            
            return rate;
        }
		
		
		 public static function getDecodeURIComponent(targetStr:String):String
        {
            var result:String = "";
            
            try
            {
                result = decodeURIComponent(targetStr);
            }
            catch (e:Error)
            {
                result = targetStr;
            }
            
            return result;
        }
		
		
		/**
		 * 获取语言数组，前面的是语言，紧跟着是语言的ID[lang,id,lang,id...]
		 */		
		public static function getLangArr(_languageArr:Array):Array{
			var $langArr:Array = [];
			for each (var $data:Array in _languageArr) 
			{
				$langArr.push($data[1]);
                $langArr.push($data[2]);
			}
			return $langArr.concat();
		}
		
		public static function generateSnapPic(sp:String, snapPic:String, isYKVideo:Boolean):String
		{
			var result:String = sp;
			
			if (isYKVideo) //优酷的图片不做验证
			{
				if (sp && sp != "null")
					result = sp;
				else if (snapPic && snapPic != "null")
					result = snapPic;
				else 
					result = null;
				
				return result;
			}
			
			//验证土豆的图片
			if (result)
            {
                result = decodeURIComponent(result);
                if (CommonTools.testLegalUrl(result))
                    return result;
            }
			
			result = decodeURIComponent(snapPic);
			if(!CommonTools.testLegalUrl(result))
				result = null;  
            
			return result;
		}
		
		public static function testLegalUrl(url:String):Boolean
        {
            var reg:RegExp = /http:\/\/[^\.\/]+?\.(tudou\.com|tdimg\.com|tudouui\.com|toodou\.com|toodou\.tv)\//ig;
            var testResult:Boolean = reg.test(url);
            return testResult;
        }
	}

}