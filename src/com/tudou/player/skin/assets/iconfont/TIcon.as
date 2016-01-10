package com.tudou.player.skin.assets.iconfont
{	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class TIcon extends Ficon
	{
		[Embed(source="tuiicon.ttf", fontName="tuiicon", mimeType="application/x-font-truetype",
		embedAsCFF="true", fontStyle="normal", fontWeight="normal")]
		private static var asset:Class; //embedAsCFF="true", 
		
		private static var fontName:String = "tuiicon";
		
		private static var intance:TIcon;
		public static function getIntance():TIcon
		{
			if (!intance)
			{
				intance = new TIcon();
			}
			return intance;
		}
		
		public function TIcon()
		{
			super();
		}
		
		/**
		 * 获取一个sprite， icon位于该sprite的最中间位置
		 * @param	text icon对应的Unicode编码
		 * @param	options icon的相关设置，支持属性color, bgWidth, bgHeight, iconWidth, iconHeight
		 * @return
		 */
		public function icon(text:String, options:Object = null):Sprite
		{
			var sprite:Sprite = new Sprite();
			if (options.hasOwnProperty('bgWidth') && options.hasOwnProperty('bgHeight'))
			{
				var bgWidth:Number = options.bgWidth;
				var bgHeight:Number = options.bgHeight;
				var iconWidth:Number = options.iconWidth;
				var iconHeight:Number = options.iconHeight;
				delete options.bgWidth;
				delete options.bgHeight;
				delete options.iconWidth;
				delete options.iconHeight;
				
				var bg:Shape = new Shape();
				bg.graphics.beginFill(0xff6600, 0);
				bg.graphics.drawRect(0, 0, bgWidth, bgHeight);
				bg.graphics.endFill();
				sprite.addChild(bg);
				
				//var shadow:FiconSprite = createIcon(fontName, text, {color:0x000000});
				//shadow.width = iconWidth;
				//shadow.x = (bgWidth - shadow.width) / 2;
				//shadow.y = (bgHeight - shadow.height) / 2 + 1;
				//sprite.addChild(shadow);
				
				var ficon:FiconSprite = createIcon(fontName, text, options);
				ficon.width = iconWidth;
				ficon.x = (bgWidth - ficon.width) / 2;
				ficon.y = (bgHeight - ficon.height) / 2;
				sprite.addChild(ficon);
			}
			
			return sprite;
		}
	}
}