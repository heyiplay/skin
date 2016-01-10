package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.skin.widgets.Widget;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	/**
	 * LocalTime
	 * 
	 * @author 8088
	 */
	public class LocalTime extends Widget
	{
		
		public function LocalTime() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			numCharacter = _assetsManager.getDisplayObject("LocalTimeNumber") as Sprite;
			
			hour1 = new Bitmap(creatBitmapData(10, 14));
			
			hour2 = new Bitmap(creatBitmapData(10, 14));
			hour2.x = hour1.width;
			
			var dot:BitmapData = creatBitmapData(6, 14);
			dot.draw( numCharacter
					, new Matrix(1, 0, 0, 1, -100, 0)
					, null
					, null
					, new Rectangle(0, 0, 6, 14)
					);
			dotBmp = new Bitmap(dot);
			dotBmp.x = hour2.width + hour2.x;
			
			minute1 = new Bitmap(creatBitmapData(10, 14));
			minute1.x = dotBmp.width + dotBmp.x;
			
			minute2 = new Bitmap(creatBitmapData(10, 14));
			minute2.x = minute1.width + minute1.x;
			
			addChild(hour1);
			addChild(hour2);
			addChild(dotBmp);
			addChild(minute1);
			addChild(minute2);
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, showTime);
			timer.start();
			showTime();
		}
		
		private function showTime(evt:TimerEvent=null):void
		{
			var now:Date = new Date();
			var h:int = now.getHours();
			var m:int = now.getMinutes();
			if (_cur_h != h)
			{
				var h1:int = h < 10 ? 0 : int(h / 10);
				var h2:int = h < 10 ? h : int(h % 10);
				changeNum(hour1, h1);
				changeNum(hour2, h2);
			}
			if (_cur_m != m)
			{
				var m1:int = m < 10 ? 0 : int(m / 10);
				var m2:int = m < 10 ? m : int(m % 10);
				changeNum(minute1, m1);
				changeNum(minute2, m2);
			}
			
			dotBmp.visible = !dotBmp.visible;
			
			_cur_h = h;
			_cur_m = m;
		}
		
		private function changeNum(bmp:Bitmap, i:int):void {
			bmp.bitmapData.dispose();
			bmp.bitmapData = creatBitmapData(10, 14);
			var matrix:Matrix = new Matrix(1, 0, 0, 1, -10 * i, 0);
			var rectangle:Rectangle = new Rectangle(0, 0, 10, 14);
			bmp.bitmapData.draw( numCharacter
							   , matrix
							   , null
							   , null
							   , rectangle
							   , true
							   );
		}
		
		private function creatBitmapData(w:Number, h:Number):BitmapData
		{
			return new BitmapData(w, h, true, 0x00FFFFFF)
		}
		
		private var hour1:Bitmap;
		private var hour2:Bitmap;
		private var dotBmp:Bitmap;
		private var minute1:Bitmap;
		private var minute2:Bitmap;
		
		private var timer:Timer;
		private var _cur_h:int = -1;
		private var _cur_m:int = -1;
		
		private var numCharacter:Sprite;
	}

}