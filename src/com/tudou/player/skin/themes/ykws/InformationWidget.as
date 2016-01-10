package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.events.TweenEvent;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Label;
	import com.tudou.player.skin.widgets.Widget;
	import com.tudou.utils.Tween;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * InformationWidget
	 * 
	 * @author 8088
	 */
	public class InformationWidget extends Widget
	{
		
		public function InformationWidget() 
		{
			super();
		}
		
		public function showInfo(info:String, autoHide:Boolean=true, autoHideTimeout:Number=5000):void
		{
			_info = info;
			info_txt.htmlText = _info;
			tweenToShow();
			if (autoHide)
			{
				if (autoHideTimer)
				{
					autoHideTimer.reset();
					autoHideTimer.delay = autoHideTimeout;
					autoHideTimer.start();
				}
				else {
					autoHideTimer = new Timer(autoHideTimeout, 1);
					autoHideTimer.addEventListener(TimerEvent.TIMER, autoHideTimerHandler);
					autoHideTimer.start();
				}
			}
			else {
				destroyTimer();
			}
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			info_txt = new Label();
			info_txt.style = "width:80%; height:20; x:20; y:0;";
			info_txt.color = 0xEEEEEE;
			info_txt.font = "Verdana";
			addChild(info_txt);
			
			var cofing:XMLList = configuration.button.(@id == "CloseButton").asset.(hasOwnProperty("@state"));
			close_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			if(parent) close_btn.x = this.parent.width - close_btn.width;
			addChild(close_btn);
			
			tween = new Tween(this);
			
			enabled = true;
		}
		
		override protected function processEnabledChange():void
		{
			if (enabled)
			{
				close_btn.enabled = true;
				close_btn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			else {
				close_btn.enabled = false;
				close_btn.removeEventListener(MouseEvent.CLICK, closeHandler);
			}
		}
		
		override protected function reSetWidth():void
		{
			if (!parent) return;
			if(info_txt) info_txt.width = this.parent.width*.8;
			if(close_btn) close_btn.x = this.parent.width - close_btn.width;
		}
		
		
		private function tweenToHide():void
		{
			tween.pause();
			tween.fadeOut(100);
			tween.addEventListener(TweenEvent.END, hiddenHandler);
		}
		
		private var parentAlpha:Number;
		private function tweenToShow():void
		{
			parentAlpha = this.parent.alpha;
			this.parent.alpha = 1;
			this.visible = true;
			tween.pause();
			tween.fadeIn(100);
		}
		
		private function hiddenHandler(evt:TweenEvent):void
		{
			tween.removeEventListener(TweenEvent.END, hiddenHandler);
			this.visible = false;
			this.parent.alpha = parentAlpha;
		}
		
		private function closeHandler(evt:MouseEvent):void
		{
			tweenToHide();
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
		
		private var info_txt:Label;
		private var close_btn:Button;
		private var tween:Tween;
		private var _info:String;
		private var autoHideTimer:Timer;
	}

}