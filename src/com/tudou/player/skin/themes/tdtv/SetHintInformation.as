package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.events.TweenEvent;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.widgets.TextView;
	import com.tudou.utils.Tween;
	import com.tudou.player.skin.widgets.Widget;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * SetInformation
	 * 
	 * @author sky
	 */
	public class SetHintInformation extends Widget
	{
		
		public function SetHintInformation() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			textView = new TextView();
			textView.setColor(0xffffff);
			textView.setFontSize(16);
			addChild(textView);
			tween = new Tween(this);
			
			enabled = true;
		}
		
		private function tweenToHide():void
		{
			tween.pause();
			tween.fadeOut(500);
			tween.addEventListener(TweenEvent.END, hiddenHandler);
		}
		
		private function tweenToShow():void
		{
			this.visible = true;
			tween.pause();
			tween.fadeIn(500);
		}
		
		private function hiddenHandler(evt:TweenEvent):void
		{
			tween.removeEventListener(TweenEvent.END, hiddenHandler);
			this.visible = false;
		}
		
		private function destroyTimer():void
		{
			if (autoHideTimer) {
				autoHideTimer.stop();
				autoHideTimer.removeEventListener(TimerEvent.TIMER, autoHideTimerHandler);
				autoHideTimer = null;
			}
		}
		
		private function autoHideTimerHandler(evt:TimerEvent):void
		{
			destroyTimer();
			tweenToHide();
		}
		
		public function showInfo( info:String ,type :int = 0,params:Array = null):void
		{
			textView.scaleX = textView.scaleY = 1;
			if (type == 0)
			{
				textView.setText(info);
			}else
			{
				var hint_desc:String = _global.language.getString(info, NetStatusEventLevel.HINT , params);
				if (hint_desc == "" || hint_desc == "非常抱歉，检测到未知错误，请尝试刷新或联系客服。") return;
				textView.setText(hint_desc);
			}
			
			layout();
			
			tweenToShow();
			if (autoHideTimer)
			{
				autoHideTimer.reset();
				autoHideTimer.start();
			}
			else {
				autoHideTimer = new Timer(2000, 1);
				autoHideTimer.addEventListener(TimerEvent.TIMER, autoHideTimerHandler);
				autoHideTimer.start();
			}
		}
		/**
		* 用以处理不同尺寸展示大小问题
		* 
		*/
		 public function layout():void {
			 rateNum = 1;
			 textView.scaleX = textView.scaleY = 1;
			 if (this.parent)
			 {
				var w : Number = this.parent.width;
				var h : Number = this.parent.height;
				
				if(h < 350){
					rateNum = h / 350;
				}else if(h > 600){
					rateNum = h / 600;
				}
			 }
			 
			_width = (textView.width + 30) < 85 ? 85 : (textView.width + 30);
			textView.scaleX = textView.scaleY = rateNum;
			textView.x = (_width * rateNum - textView.width) / 2 ;
			textView.y = (_height * rateNum - textView.height) / 2 ;
			
			style = " height:" + (_height *rateNum) + "; width:" + (_width *rateNum) + "; "
			
		 }
		
		private var _width:Number = 85;
		private var _height:Number = 35;
		private var tween:Tween;
		private var rateNum:Number;
		private var textView:TextView;
		private var autoHideTimer:Timer;
	}

}