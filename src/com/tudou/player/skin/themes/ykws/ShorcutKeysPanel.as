package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.events.TweenEvent;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.TextView;
	import com.tudou.utils.Tween;
	import com.tudou.player.skin.widgets.Widget;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ShorcutKeysPanel
	 * 
	 * @author sky
	 */
	public class ShorcutKeysPanel extends Widget
	{
		
		public function ShorcutKeysPanel() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			sp = new Sprite();
			addChild(sp);
			bg = new PanelBg(_assetsManager.getDisplayObject("PanelBackground") as Sprite);
			sp.addChild(bg);
			
			btm_line = new Shape();
			sp.addChild(btm_line);
			
			titleView = new TextView();
			titleView.setColor(0xffffff);
			titleView.setFontSize(14);
			titleView.setFormatStyle("letterSpacing" , 1);
			
			titleView.setBold(true);
			sp.addChild(titleView);
			titleView.x = 20;
			titleView.y = 17;
			
			textView = new TextView();
			textView.setColor(0xbbbbbb);
			textView.setFormatStyle("leading" , 10);
			textView.setFontSize(12);
			sp.addChild(textView);
			textView.y = 50;
			
			var cofing:XMLList = configuration.button.(@id == "CloseButton").asset.(hasOwnProperty("@state"));
			close_btn = new Button
					( _assetsManager.getDisplayObject(cofing.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(cofing.(@state == Keyword.DISABLED).@id)
					);
			close_btn.y = 12;
			sp.addChild(close_btn);
			
			tween = new Tween(this);
			
			enabled = true;
		}
		
		private function tweenToHide():void
		{
			tween.pause();
			tween.fadeOut(200);
			tween.addEventListener(TweenEvent.END, hiddenHandler);
		}
		
		private function tweenToShow():void
		{
			this.visible = true;
			tween.pause();
			tween.fadeIn(200);
		}
		
		private function hiddenHandler(evt:TweenEvent):void
		{
			tween.removeEventListener(TweenEvent.END, hiddenHandler);
			this.visible = false;
		}
		
		private function closeHandler(evt:MouseEvent):void
		{
			tweenToHide();
		}
		
		public function showInfo( info:String ):void
		{
			if (info && info != "")
			{
				textView.setText(info);
				titleView.setText("快捷键信息");
				layout();
			
				tweenToShow();
				
			}
			
		}
		override protected function processEnabledChange():void
		{
			if (enabled)
			{
				close_btn.enabled = enabled;
				close_btn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			else {
				close_btn.enabled = enabled;
				close_btn.removeEventListener(MouseEvent.CLICK, closeHandler);
			}
		}
		
		public function layout():void {
			
			var _w:Number = Math.max(textView.width, titleView.width);
			_width = (_w + 50) < 150 ? 150 : (_w + 50);
			_height = (textView.height + 75) < 120 ? 120 : (textView.height + 75);
			bg.width = _width;
			bg.height = _height;
			btm_line.graphics.clear();
			btm_line.graphics.beginFill(0xFFFFFF, .3);
			btm_line.graphics.drawRect(10, 45, _width - 20, 1);
			btm_line.graphics.endFill();
			
			textView.x = (_width  - textView.width) / 2 ;
			
			close_btn.x = (_width  - close_btn.width) - 7 ;
			
			style = " height:" + _height + "; width:" + _width + "; "
		}
		private var sp:Sprite;
		
		private var bg:PanelBg;
		private var btm_line:Shape;
		private var _width:Number = 150;
		private var _height:Number = 120;
		private var tween:Tween;
		private var close_btn:Button;
		private var titleView:TextView;
		
		private var textView:TextView;
	}

}