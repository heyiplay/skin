package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.layout.LayoutSprite;
	import com.tudou.player.config.ColorMode;
	import com.tudou.player.config.ProportionMode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.configuration.Keyword;
	import com.tudou.player.skin.events.ScrubberEvent;
	import com.tudou.player.skin.widgets.Button;
	import com.tudou.player.skin.widgets.Label;
	import com.tudou.player.skin.widgets.LabelButton;
	import com.tudou.player.skin.widgets.RadioButton;
	import com.tudou.player.skin.widgets.Checkbox;
	import com.tudou.player.skin.widgets.SliderBar;
	import com.tudou.player.skin.widgets.TabButton;
	import com.tudou.player.skin.widgets.SwitchButton;
	import com.tudou.player.skin.widgets.Widget;
	import flash.display.DisplayObject;
	import flash.events.NetStatusEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import flash.text.TextField;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	/**
	 * SetPanel
	 * 
	 * @author 8088
	 */
	public class SetPanel extends Widget
	{
		
		public function SetPanel() 
		{
			super();
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			bg = new PanelBg(_assetsManager.getDisplayObject("PanelBackground") as Sprite);
			bg.width = this.width;
			bg.height = this.height;
			addChild(bg);
			
			//标签
			buildTabBtns();
			
			var cline:Sprite = _assetsManager.getDisplayObject("TabAreaCline") as Sprite;
			cline.width = this.width -20;
			cline.x = 10;
			cline.y = 50;
			addChild(cline);
			
			//标签页
			buildTabs();
			
			//底部按钮
			buildBottomBtn();
			
			//默认显示第一个标签页
			view = views[1];
			
		}
		
		public function cancel():void
		{
			cancelHandler(null);
		}
		
		/**
		 * 设置显示当前标签页
		 */
		public function set view(id:String):void
		{
			if (id == "") id = views[0];
			setCur(id);
		}
		
		/**
		 * 启用可交互全屏设置控件
		 */
		public function setAllowFullScreenInteractiveEnabled(value:Boolean):void
		{
			allowFullScreenInteractiveCheckbox.enabled = value;
			if (!value) allowFullScreenInteractiveCheckbox.check = value;
		}
		
		public function get allowFullScreenInteractive():Boolean
		{
			return _allowFullScreenInteractive;
		}
		
		public function set allowFullScreenInteractive(value:Boolean):void
		{
			if (_allowFullScreenInteractive == value) return;
			_allowFullScreenInteractive = value;
			allowFullScreenInteractiveCheckbox.check = _allowFullScreenInteractive;
		}
		
		/**
		 * 启用硬件加速设置控件
		 */
		public function setHardwareAccelerateEnabled(value:Boolean):void
		{
			hardwareAccelerateBtn.enabled = value;
			if (!value) hardwareAccelerateBtn.on = value;
		}
		
		public function get hardwareAccelerate():Boolean
		{
			return _hardwareAccelerate;
		}
		
		public function set hardwareAccelerate(value:Boolean):void
		{
			if (_hardwareAccelerate == value) return;
			_hardwareAccelerate = value;
			hardwareAccelerateBtn.on = value;
			
		}
		
		public function get brightness():Number
		{
			return _brightness;
		}
		
		public function set brightness(num:Number):void
		{
			if (num<0 || num>1) return;
			if (_brightness == num) return;
			_brightness = int(num*100)/100;
			colorSliderBars["亮度"].slide = _brightness;
			colorTxts["亮度"].text = int(_brightness * 200 - 100) + "%";
		}
		
		public function get contrast():Number
		{
			return _contrast;
		}
		
		public function set contrast(num:Number):void
		{
			if (num<0 || num>1) return;
			if (_contrast == num) return;
			_contrast = int(num*100)/100;
			colorSliderBars["对比度"].slide = _contrast;
			colorTxts["对比度"].text = int(_contrast * 200 - 100) + "%";
		}
		
		public function get saturation():Number
		{
			return _saturation;
		}
		
		public function set saturation(num:Number):void
		{
			if (num<0 || num>1) return;
			if (_saturation == num) return;
			_saturation = int(num*100)/100;
			colorSliderBars["饱和度"].slide = _saturation;
			colorTxts["饱和度"].text = int(_saturation * 200 - 100) + "%";
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
		public function set mode(value:String):void
		{
			if (value == _mode) return;
			_mode = value;
			
			if (oldRadioColorBtn)
			{
				oldRadioColorBtn.check = false;
			}
			colorRadioBtns[_mode].check = true;
			
			switch(_mode)
			{
				case ColorMode.CUSTOM:
					//ignorl..
					break;
				case ColorMode.BRIGHT:
					brightness = lightMode[0];
					contrast = lightMode[1];
					saturation = lightMode[2];
					break;
				case ColorMode.VIVID:
					brightness = vividMode[0];
					contrast = vividMode[1];
					saturation = vividMode[2];
					break;
				case ColorMode.THEATRE:
					brightness = theaterMode[0];
					contrast = theaterMode[1];
					saturation = theaterMode[2];
					break;
			}
			
			oldRadioColorBtn = colorRadioBtns[_mode];
			
		}
		
		/**
		 * 设置比例
		 */
		public function get proportion():String
		{
			return _proportion;
		}
		
		public function set proportion(value:String):void
		{
			if (_proportion == value) return;
			_proportion = value;
			if (oldRadioProportionBtn)
			{
				oldRadioProportionBtn.check = false;
			}
			viewRadioBtns[_proportion].check = true;
			//..
			oldRadioProportionBtn = viewRadioBtns[_proportion];
		}
		
		public function setProportionEnabled(value:Boolean):void
		{
			if (viewRadioBtns == null) return;
			
			for (var key:String in viewRadioBtns)
			{
				var btn:RadioButton = viewRadioBtns[key] as RadioButton;
				if (btn) btn.enabled = value;
			
			}
		}
		
		/**
		 * 设置缩放
		 */
		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scale(num:Number):void
		{
			if (num<0 || num>1) return;
			if (_scale == num) return;
			_scale =  int(num*100)/100;
			zoomSlider.slide = _scale;
			zoomTxt.text = int(Number(_scale) * 100) + "%";
			
		}
		
		public function setScaleEnabled(value:Boolean):void
		{
			zoomSlider.enabled = value;
		}
		
		/**
		 * 设置旋转角度
		 */
		public function get rotationAngle():Number
		{
			return _rotationAngle;
		}
		
		public function set rotationAngle(value:Number):void
		{
			if (_rotationAngle == value) return;
			if (value >= 360) value = value % 360;
			if (value <= -360) value = value % -360;
			_rotationAngle = value;
		}
		
		public function setRotationEnabled(value:Boolean):void
		{
			leftBtn.enabled = value;
			rightBtn.enabled = value;
			filpBtn.enabled = value;
		}
		
		
		public function reset():void
		{
			setParamsStatus = 0;
			var arrOld:Array = [old_allowFullScreenInteractive , old_hardwareAccelerate , old_brightness , old_contrast , old_saturation, old_mode, old_proportion, old_scale, old_rotationAngle];
			var arr:Array = [_allowFullScreenInteractive , _hardwareAccelerate , _brightness , _contrast , _saturation, _mode, _proportion, _scale, _rotationAngle];
			for (var i:int = 0, l:int = arrOld.length; i < l; i++ )
			{
				if (arrOld[i] != arr[i])
				{
					setParamsStatus = i;
					break;
				}
			}
			//播放
			old_allowFullScreenInteractive = _allowFullScreenInteractive;
			old_hardwareAccelerate = _hardwareAccelerate;
			
			//色彩
			old_brightness = _brightness;
			old_contrast = _contrast;
			old_saturation = _saturation;
			old_mode = _mode;
			
			//画面
			old_proportion = _proportion;
			old_scale = _scale;
			old_rotationAngle = _rotationAngle;
			
			//其他..
		}
		
		
		// Internal..
		//
		private function buildTabBtns():void
		{
			var drag_area:Sprite = new Sprite();
			drag_area.graphics.clear();
			drag_area.graphics.beginFill(0xff0000, 0);
			drag_area.graphics.drawRect(10, 10, 320, 40);
			drag_area.graphics.endFill();
			drag_area.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			drag_area.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			drag_area.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addChild(drag_area);
			
			var config:XMLList = configuration.tabbutton;
			var tab_len:int = config.length();
			tab_btns = { };
			views = [];
			
			for (var i:int = 0; i != tab_len; i++)
			{
				var btn_config:XML = config[i];
				var id:String = btn_config.@label;
				views.push(id);
				var btn:TabButton = new TabButton
									( id
									, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.NORMAL).@id)
									, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.FOCUSED).@id)
									, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.PRESSED).@id)
									, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.DISABLED).@id)
									);
				btn.normalColor = btn_normal_color;
				btn.focusedColor = btn_focused_color;
				btn.pressedColor = btn_pressed_color;
				btn.id = id;
				btn.style = btn_config.@style;
				btn.enabled = true;
				tab_btns[id] = btn;
				addChild(btn);
				
				btn.addEventListener(MouseEvent.CLICK, tabClick);
			}
			
		}
		
		private function onMouseOver(evt:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.HAND;
		}
		private function onMouseOut(evt:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
		}
		private function onStartDrag(evt:MouseEvent):void
		{
			var controlbar_height:Number = 0.0;
			if (_global.config && _global.config.hasOwnProperty("controlBarHeight"))
			{
				controlbar_height = _global.config.controlBarHeight;
			}
			var _rect:Rectangle = new Rectangle();
			_rect.x = this.parent.x;
			_rect.y = this.parent.y;
			_rect.width = this.parent.width - this.width;
			_rect.height = this.parent.height - this.height - controlbar_height;
			
			this.startDrag(false, _rect);
			
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
		}
		
		private function onStopDrag(evt:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			this.stopDrag();
		}
		
		private function tabClick(evt:MouseEvent):void
		{
			var btn:TabButton = evt.target as TabButton;
			
			setCur(btn.id);
			
		}
		
		private function buildTabs():void
		{
			//根据标签页的个数， 分别构建4个标签页
			var tabs_num:int = configuration.tab.length();
			tabs = { };
			for (var i:int; i != tabs_num; i++)
			{
				var tab_container:Sprite = new Sprite();
				tab_container.x = 20;
				tab_container.y = 62;
				tab_container.name = configuration.tab[i].@name;
				var config:XML = configuration.tab[i];
				
				if (tab_container.name == "播放") buildPlayTab(tab_container, config);
				if (tab_container.name == "色彩") buildColorTab(tab_container, config);
				if (tab_container.name == "画面") buildViewTab(tab_container, config);
				if (tab_container.name == "其他") buildOtherTab(tab_container, config);
				
				tabs[tab_container.name] = tab_container;
				addChild(tab_container);
			}
			
			
		}
		
		/**
		 * 播放设置标签页
		 * 
		 * @param container:Sprite 标签页容器
		 * @param config:XML 标签页配置
		 */
		private var allowFullScreenInteractiveCheckbox:Checkbox;
		private var hardwareAccelerateBtn:SwitchButton;
		private function buildPlayTab(container:Sprite, config:XML):void
		{
			
			var btn_config:XMLList; 
			btn_config = config.checkbox.(@id == "AllowFullScreenInteractiveCheckbox");
			allowFullScreenInteractiveCheckbox = new Checkbox
				( btn_config.@label
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.DISABLED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_DISABLED).@id)
				);
			allowFullScreenInteractiveCheckbox.style = btn_config.@style;
			allowFullScreenInteractiveCheckbox.id = btn_config.@id;
			allowFullScreenInteractiveCheckbox.enabled = true;
			allowFullScreenInteractiveCheckbox.check = default_allowFullScreenInteractive;
			container.addChild(allowFullScreenInteractiveCheckbox);
			
			allowFullScreenInteractiveCheckbox.addEventListener(MouseEvent.CLICK, onPlaySetHandler)
			
			btn_config = config.checkbox.(@id == "AutoMatchClarityCheckbox");
			var checkbox2:Checkbox = new Checkbox
				( btn_config.@label
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.DISABLED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_DISABLED).@id)
				);
			checkbox2.style = btn_config.@style;
			checkbox2.id = btn_config.@label;
			checkbox2.enabled = false;
			checkbox2.check = false;
			container.addChild(checkbox2);
			
			btn_config = config.checkbox.(@id == "ShowRightToolCheckbox");
			var checkbox3:Checkbox = new Checkbox
				( btn_config.@label
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.DISABLED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_DISABLED).@id)
				);
			checkbox3.style = btn_config.@style;
			checkbox3.id = btn_config.@label;
			checkbox3.enabled = false;
			checkbox3.check = false;
			container.addChild(checkbox3);
			
			
			
			//checkbox1.addEventListener(MouseEvent.MOUSE_DOWN, radioColor);
			
			
			var ttl3:Label = new Label();
			ttl3.text = "硬件加速：";
			ttl3.style = "x:170; y:10; width:80; height:20;";
			ttl3.color = 0x999999;
			ttl3.font = "宋体";
			container.addChild(ttl3);
			
			btn_config = config.switchbutton.(@id == "HardwareAccelerateSwitchButton");
			hardwareAccelerateBtn = new SwitchButton
					( _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.ON_NORMAL).@id)
					, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.OFF_NORMAL).@id)
					, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.ON_FOCUSED).@id)
					, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.OFF_FOCUSED).@id)
					, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.ON_DISABLED).@id)
					, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.OFF_DISABLED).@id)
					);
			hardwareAccelerateBtn.style = btn_config.@style;
			hardwareAccelerateBtn.id = btn_config.@id;
			hardwareAccelerateBtn.enabled = false;
			hardwareAccelerateBtn.on = false;
			container.addChild(hardwareAccelerateBtn);
			
			hardwareAccelerateBtn.addEventListener(MouseEvent.CLICK, onPlaySetHandler);
		}
		
		private function setAllowFullScreenInteractive(value:Boolean):void
		{
			if (allowFullScreenInteractive == value) return;
			
			allowFullScreenInteractive = value;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_ALLOW_FULL_SCREEN_INTERACTIVE, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:allowFullScreenInteractive }}
				)
			);
		}
		
		private function setHardwareAccelerate(value:Boolean):void
		{
			if (hardwareAccelerate == value) return;
			
			hardwareAccelerate = value;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_HARDWARE_ACCELERATE, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:hardwareAccelerate }}
				)
			);
			
		}
		
		/**
		 * 色彩设置标签页
		 * 
		 * @param container:Sprite 标签页容器
		 * @param config:XML 标签页配置
		 */
		private var colorRadioBtns:Object;
		private var oldRadioColorBtn:RadioButton;
		private var colorSliderBars:Object;
		private var colorTxts:Object;
		private function buildColorTab(container:Sprite, config:XML):void
		{
			var ttl1:Label = new Label();
			ttl1.text = "亮　度：";
			ttl1.style = "x:10; y:5; width:60; height:20;";
			ttl1.color = 0xCCCCCC;
			ttl1.font = "宋体";
			container.addChild(ttl1);
			
			var ttl2:Label = new Label();
			ttl2.text = "对比度：";
			ttl2.style = "x:10; y:35; width:60; height:20;";
			ttl2.color = 0xCCCCCC;
			ttl1.font = "宋体";
			container.addChild(ttl2);
			
			var ttl3:Label = new Label();
			ttl3.text = "饱和度：";
			ttl3.style = "x:10; y:65; width:60; height:20;";
			ttl3.color = 0xCCCCCC;
			ttl1.font = "宋体";
			container.addChild(ttl3);
			
			var slider_n:int = config.sliderbar.length();
			var i:int;
			var id:String = "";
			colorSliderBars = { };
			colorTxts = { };
			for (i=0; i != slider_n; i++)
			{
				id = config.sliderbar[i].@name;
				var sliderBar:SliderBar = new SliderBar
					( _assetsManager.getDisplayObject(config.sliderbar[i].asset.(@state == Keyword.TRACK).@id)
					, _assetsManager.getDisplayObject(config.sliderbar[i].asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(config.sliderbar[i].asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(config.sliderbar[i].asset.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(config.sliderbar[i].asset.(@state == Keyword.DISABLED).@id)
					);
				sliderBar.style = config.sliderbar[i].@style;
				sliderBar.id = id;
				sliderBar.enabled = true;
				colorSliderBars[id] = sliderBar;
				sliderBar.addEventListener(NetStatusEvent.NET_STATUS, sliderHandler);
				container.addChild(sliderBar);
				
				var txt:Label = new Label();
				txt.style = "x:"+(sliderBar.x+sliderBar.width+15)+"; y:"+(sliderBar.y-4)+"; width:34; height:18; background:#11CCCCCC;";
				txt.align = "center";
				txt.id = id;
				txt.size = 11;
				if(sliderBar.enabled) txt.color = 0xCCCCCC;
				else txt.color = 0x666666;
				colorTxts[id] = txt;
				container.addChild(txt);
			}
			
			var ttl4:Label = new Label();
			ttl4.text = "模　式：";
			ttl4.style = "x:10; y:100; width:60; height:20;";
			ttl4.color = 0xCCCCCC;
			ttl1.font = "宋体";
			container.addChild(ttl4);
			
			var btn_n:int = config.radiobutton.length();
			colorRadioBtns = {};
			for (i=0; i != btn_n; i++)
			{
				id = config.radiobutton[i].@id;
				var btn:RadioButton = new RadioButton
					( config.radiobutton[i].@label
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.CHECK_NORMAL).@id)
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.CHECK_FOCUSED).@id)
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.DISABLED).@id)
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.CHECK_DISABLED).@id)
					);
				btn.style = config.radiobutton[i].@style;
				btn.id = id;
				btn.enabled = true;
				colorRadioBtns[id] = btn;
				container.addChild(btn);
				btn.addEventListener(MouseEvent.MOUSE_DOWN, radioColor);
			}
			
			mode = default_mode;
		}
		
		private function radioColor(evt:MouseEvent):void
		{
			var radioBtn:RadioButton = evt.target as RadioButton;
			
			setColorMode(radioBtn.id)
			
		}
		
		private function setColorMode(id:String):void
		{
			if (colorRadioBtns[id] == oldRadioColorBtn) return;
			_mode = id;
			if (oldRadioColorBtn)
			{
				oldRadioColorBtn.check = false;
			}
			colorRadioBtns[id].check = true;
			
			switch(id)
			{
				case ColorMode.CUSTOM:
					setBrightness(_brightness);
					setContrast(_contrast);
					setSaturation(_saturation);
					break;
				case ColorMode.BRIGHT:
					setBrightness(lightMode[0]);
					setContrast(lightMode[1]);
					setSaturation(lightMode[2]);
					break;
				case ColorMode.VIVID:
					setBrightness(vividMode[0]);
					setContrast(vividMode[1]);
					setSaturation(vividMode[2]);
					break;
				case ColorMode.THEATRE:
					setBrightness(theaterMode[0]);
					setContrast(theaterMode[1]);
					setSaturation(theaterMode[2]);
					break;
			}
			
			oldRadioColorBtn = colorRadioBtns[id];
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_COLOR_MODE, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:id, action:MouseEvent.MOUSE_DOWN}}
				)
			);
			
		}
		
		private function setBrightness(num:Number):void
		{
			if (brightness == num) return;
			
			brightness = num;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_COLOR_BRIGHTNESS, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:brightness}}
				)
			);
		}
		
		private function setContrast(num:Number):void
		{
			if (contrast == num) return;
			
			contrast = num;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_COLOR_CONTRAST, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:contrast}}
				)
			);
		}
		
		private function setSaturation(num:Number):void
		{
			if (saturation == num) return;
			
			saturation = num;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_COLOR_SATURATION, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:saturation}}
				)
			);
		}
		
		/**
		 * 画面设置标签页
		 * 
		 * @param container:Sprite 标签页容器
		 * @param config:XML 标签页配置
		 */
		private var viewRadioBtns:Object;
		private var oldRadioProportionBtn:RadioButton;
		private var zoomSlider:SliderBar;
		private var zoomTxt:Label;
		private var leftBtn:Button;
		private var rightBtn:Button;
		private var filpBtn:Button;
		private function buildViewTab(container:Sprite, config:XML):void
		{
			var ttl1:Label = new Label();
			ttl1.text = "比　例：";
			ttl1.style = "x:16; y:10; width:60; height:20;";
			ttl1.color = 0xCCCCCC;
			ttl1.font = "宋体";
			container.addChild(ttl1);
			
			var btn_n:int = config.radiobutton.length();
			viewRadioBtns = {};
			for (var i:int; i != btn_n; i++)
			{
				var id:String = config.radiobutton[i].@id;
				var btn:RadioButton = new RadioButton
					( config.radiobutton[i].@label
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.CHECK_NORMAL).@id)
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.CHECK_FOCUSED).@id)
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.DISABLED).@id)
					, _assetsManager.getDisplayObject(config.radiobutton[i].asset.(@state == Keyword.CHECK_DISABLED).@id)
					);
				btn.style = config.radiobutton[i].@style;
				btn.id = id;
				btn.enabled = true;
				viewRadioBtns[id] = btn;
				container.addChild(btn);
				btn.addEventListener(MouseEvent.MOUSE_DOWN, radioProportion);
			}
			
			proportion = default_proportion;
			
			var ttl2:Label = new Label();
			ttl2.text = "缩　放：";
			ttl2.style = "x:16; y:50; width:60; height:20;";
			ttl2.color = 0xCCCCCC;
			ttl1.font = "宋体";
			container.addChild(ttl2);
			
			zoomSlider = new SliderBar
				( _assetsManager.getDisplayObject(config.sliderbar.asset.(@state == Keyword.TRACK).@id)
				, _assetsManager.getDisplayObject(config.sliderbar.asset.(@state == Keyword.NORMAL).@id)
				, _assetsManager.getDisplayObject(config.sliderbar.asset.(@state == Keyword.FOCUSED).@id)
				, _assetsManager.getDisplayObject(config.sliderbar.asset.(@state == Keyword.PRESSED).@id)
				, _assetsManager.getDisplayObject(config.sliderbar.asset.(@state == Keyword.DISABLED).@id)
				);
			zoomSlider.style = config.sliderbar.@style;
			zoomSlider.id = config.sliderbar.@name;
			zoomSlider.enabled = true;
			zoomSlider.addEventListener(NetStatusEvent.NET_STATUS, sliderHandler);
			container.addChild(zoomSlider);
			
			zoomTxt = new Label();
			zoomTxt.style = "x:244; y:51; width:38; height:18; background:#11CCCCCC;";
			zoomTxt.align = "center";
			if(zoomSlider.enabled) zoomTxt.color = 0xCCCCCC;
			else zoomTxt.color = 0x666666;
			zoomTxt.size = 11;
			container.addChild(zoomTxt);
			
			scale = default_scale;
			
			var ttl3:Label = new Label();
			ttl3.text = "旋　转：";
			ttl3.style = "x:16; y:90; width:60; height:20;";
			ttl3.color = 0xCCCCCC;
			ttl1.font = "宋体";
			container.addChild(ttl3);
			
			
			var btn_cofing:XMLList;
			btn_cofing = config.button.(@id == "LeftRotationButton");
			leftBtn = new Button
					( _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.DISABLED).@id)
					);
			leftBtn.x = 72;
			leftBtn.y = 90;
			leftBtn.enabled = true;
			container.addChild(leftBtn);
			
			btn_cofing = config.button.(@id == "RightRotationButton");
			rightBtn = new Button
					( _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.DISABLED).@id)
					);
			rightBtn.x = 140;
			rightBtn.y = 90;
			rightBtn.enabled = true;
			container.addChild(rightBtn);
			
			btn_cofing = config.button.(@id == "VideoFlipButton");
			filpBtn = new Button
					( _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.NORMAL).@id)
					, _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.FOCUSED).@id)
					, _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.PRESSED).@id)
					, _assetsManager.getDisplayObject(btn_cofing.asset.(@state == Keyword.DISABLED).@id)
					);
			filpBtn.x = 210;
			filpBtn.y = 90;
			filpBtn.enabled = true;
			container.addChild(filpBtn);
			
			zoomSlider.addEventListener(NetStatusEvent.NET_STATUS, sliderHandler);
			
			leftBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			rightBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			filpBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
		}
		
		private function radioProportion(evt:MouseEvent):void
		{
			var radioBtn:RadioButton = evt.target as RadioButton;
			
			if (proportion == radioBtn.id) return;
			
			proportion = radioBtn.id;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_PROPORTION_MODE, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:proportion, action:evt.type}}
				)
			);
			
		}
		
		private function setProportionMode(value:String):void
		{
			if (proportion == value) return;
			
			proportion = value;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_PROPORTION_MODE, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:proportion}}
				)
			);
			
		}
		
		private function setScale(num:Number):void
		{
			if (scale == num) return;
			
			scale = num;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_SCALE, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:scale}}
				)
			);
		}
		
		private function setRotationAngle(num:Number):void
		{
			if (rotationAngle == num) return;
			
			rotationAngle = num;
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_ROTATION_ANGLE, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:rotationAngle }}
				)
			);
		}
		
		
		/**
		 * 其他设置标签页
		 * 
		 * @param container:Sprite 标签页容器
		 * @param config:XML 标签页配置
		 */
		private var otherBtn1:Checkbox;
		private var otherBtn2:Checkbox;
		private var otherBtn3:Checkbox;
		private function buildOtherTab(container:Sprite, config:XML):void
		{
			var btn_config:XMLList; 
			btn_config = config.checkbox.(@id == "Checkbox1");
			otherBtn1 = new Checkbox
				(  btn_config.@label
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.DISABLED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_DISABLED).@id)
				);
			otherBtn1.style = btn_config.@style;
			otherBtn1.id = btn_config.@label;
			otherBtn1.enabled = true;
			otherBtn1.check = true;
			container.addChild(otherBtn1);
			//btn.addEventListener(MouseEvent.MOUSE_DOWN, radioColor);
			
			btn_config = config.checkbox.(@id == "Checkbox2");
			otherBtn2 = new Checkbox
				( btn_config.@label
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.DISABLED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_DISABLED).@id)
				);
			otherBtn2.style = btn_config.@style;
			otherBtn2.id = btn_config.@label;
			otherBtn2.enabled = true;
			otherBtn2.check = true;
			container.addChild(otherBtn2);
			
			btn_config = config.checkbox.(@id == "Checkbox3");
			otherBtn3 = new Checkbox
				( btn_config.@label
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_NORMAL).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_FOCUSED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.DISABLED).@id)
				, _assetsManager.getDisplayObject(btn_config.asset.(@state == Keyword.CHECK_DISABLED).@id)
				);
			otherBtn3.style = btn_config.@style;
			otherBtn3.id = btn_config.@label;
			otherBtn3.enabled = true;
			container.addChild(otherBtn3);
			
			
			otherBtn1.addEventListener(MouseEvent.CLICK, checkboxClickHandler);
			otherBtn2.addEventListener(MouseEvent.CLICK, checkboxClickHandler);
			otherBtn3.addEventListener(MouseEvent.CLICK, checkboxClickHandler);
		}
		
		//面板底部按钮
		private function buildBottomBtn():void
		{
			var btm_line:Shape = new Shape();
			btm_line.graphics.beginFill(0xFFFFFF, .1);
			btm_line.graphics.drawRect(10, 199, bg.width-20, 1);
			btm_line.graphics.endFill();
			addChild(btm_line);
			
			var btm_v_line:Shape = new Shape();
			btm_v_line.graphics.beginFill(0xFFFFFF, .1);
			btm_v_line.graphics.drawRect(112, 200, 1, 29);
			btm_v_line.graphics.endFill();
			addChild(btm_v_line);
			
			var btm_v_line2:Shape = new Shape();
			btm_v_line2.graphics.beginFill(0xFFFFFF, .1);
			btm_v_line2.graphics.drawRect(227, 200, 1, 29);
			btm_v_line2.graphics.endFill();
			addChild(btm_v_line2);
			
			ok_btn = new LabelButton("确定");
			ok_btn.normalColor = 0x999999;
			ok_btn.focusedColor = 0xCCCCCC;
			ok_btn.pressedColor = 0xCCCCCC;
			ok_btn.style = "x:10; y:200; width:100; height:28;";
			ok_btn.enabled = true;
			addChild(ok_btn);
			
			default_btn = new LabelButton("恢复设置");
			default_btn.normalColor = 0x999999;
			default_btn.focusedColor = 0xCCCCCC;
			default_btn.pressedColor = 0xCCCCCC;
			default_btn.style = "x:115; y:200; width:110; height:28;";
			default_btn.enabled = true;
			addChild(default_btn);
			
			cancel_btn = new LabelButton("取消");
			cancel_btn.normalColor = 0x999999;
			cancel_btn.focusedColor = 0xCCCCCC;
			cancel_btn.pressedColor = 0xCCCCCC;
			cancel_btn.style = "x:230; y:200; width:100; height:28;";
			cancel_btn.enabled = true;
			addChild(cancel_btn);
			
			ok_btn.addEventListener(MouseEvent.CLICK, okHandler);
			default_btn.addEventListener(MouseEvent.CLICK, defaultHandler);
			cancel_btn.addEventListener(MouseEvent.CLICK, cancelHandler);
			
		}
		
		private function cancelHandler(evt:MouseEvent):void
		{
			//播放
			if (old_allowFullScreenInteractive != _allowFullScreenInteractive) setAllowFullScreenInteractive(old_allowFullScreenInteractive);
			if (old_hardwareAccelerate != _hardwareAccelerate) setHardwareAccelerate(old_hardwareAccelerate);
			
			//色彩
			if (old_brightness != _brightness) setBrightness(old_brightness);
			if (old_contrast != _contrast) setContrast(old_contrast);
			if (old_saturation != _saturation) setSaturation(old_saturation);
			if (old_mode != _mode) setColorMode(old_mode);
			
			//画面
			if (old_proportion!=_proportion) setProportionMode(old_proportion);
			if (old_scale != _scale) setScale(old_scale);
			if (old_rotationAngle != _rotationAngle) setRotationAngle(old_rotationAngle);
			
			//其他..
			
			this.visible = false;
		}
		
		private function defaultHandler(evt:MouseEvent):void
		{
			switch(cur_tab)
			{
				case "播放":
					setAllowFullScreenInteractive(default_allowFullScreenInteractive);
					setHardwareAccelerate(default_hardwareAccelerate);
					break;
				case "色彩":
					setBrightness(default_brightness);
					setContrast(default_contrast);
					setSaturation(default_saturation);
					setColorMode(default_mode);
					break;
				case "画面":
					setProportionMode(default_proportion);
					setScale(default_scale);
					setRotationAngle(default_rotationAngle);
					break;
				case "其他":
					//...
					break;
			}
		}
		
		private function okHandler(evt:MouseEvent):void
		{
			reset();
			var data:String = "";
			if (setParamsStatus == 8) data = NetStatusCommandCode.SET_ROTATION_ANGLE;
			if (setParamsStatus != 0) 
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusCommandCode.SET_PANEL_RARAMS_CHANGED, level:NetStatusEventLevel.COMMAND, data:{ id:this.id ,action:evt.type,value:data}}
				)
			);
			this.visible = false;
		}
		
		private function setCur(id:String):void
		{
			cur_tab = id;
			setBtnCur(id);
			setTabCur(id);
		}
		
		private function setBtnCur(id:String):void
		{
			var btn:TabButton = tab_btns[id] as TabButton;
			if (!btn) return;
			for each(var _btn:TabButton in tab_btns)
			{
				if (_btn) _btn.cur = false;
			}
			btn.cur = true;
		}
		
		private function setTabCur(id:String):void
		{
			var tab:Sprite = tabs[id] as Sprite;
			for each(var _tab:Sprite in tabs)
			{
				if (_tab) _tab.visible = false;
			}
			tab.visible = true;
		}
		
		//开关按钮控制事件
		private function onPlaySetHandler(evt:MouseEvent):void
		{
			var command_code:String = "";
			var _value:Boolean;
			var btn:LayoutSprite = evt.target as LayoutSprite;
			
			if (btn)
			{
				switch(btn.id)
				{
					case "AllowFullScreenInteractiveCheckbox":
						_allowFullScreenInteractive = Checkbox(btn).check;
						_value = _allowFullScreenInteractive;
						command_code = NetStatusCommandCode.SET_ALLOW_FULL_SCREEN_INTERACTIVE;
						break;
					case "AutoMatchClarity":
						
						break;
					case "ShowRightTool":
						
						break;
					case "HardwareAccelerateSwitchButton":
						_hardwareAccelerate = SwitchButton(btn).on;
						_value = _hardwareAccelerate;
						command_code = NetStatusCommandCode.SET_HARDWARE_ACCELERATE;
						break;
				}
				
				dispatchEvent( new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, { code:command_code, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:_value, action:evt.type}}
					)
				);
			}
		}
		
		//复选框控制事件
		private function checkboxClickHandler(evt:MouseEvent):void
		{
			var btn:Checkbox = evt.target as Checkbox;
			var command_code:String = "";
			var _value:Boolean;
			if (btn)
			{
				switch(btn.id)
				{
					case "自动连播":
						_autoPlayNext = btn.check;
						_value = _autoPlayNext;
						command_code = NetStatusCommandCode.SET_AUTO_CONTINUOUS_PLAY;
						break;
				}
			}
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:command_code, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:_value, action:evt.type}}
				)
			);
		}
		
		//按钮控制事件
		private var _filp:Boolean;
		private function btnClickHandler(evt:MouseEvent):void
		{
			var btn:Button = evt.target as Button;
			var command_code:String = "";
			var _value:Number;
			if (btn)
			{
				switch(btn)
				{
					case leftBtn:
						rotationAngle -= 90;
						_value = rotationAngle;
						command_code = NetStatusCommandCode.SET_ROTATION_LEFT;
						break;
					case rightBtn:
						rotationAngle += 90;
						_value = rotationAngle;
						command_code = NetStatusCommandCode.SET_ROTATION_RIGHT;
						break;
					case filpBtn:
						_filp = !_filp;
						rotationAngle += 180*(_filp?1:-1);
						_value = rotationAngle;
						command_code = NetStatusCommandCode.SET_FILP;
						break;
				}
			}
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:command_code, level:NetStatusEventLevel.COMMAND, data:{ id:this.id, value:_value, action:evt.type }}
				)
			);
		}
		
		//拖动条控制事件
		private function sliderHandler(evt:NetStatusEvent):void
		{
			if (cur_tab == "色彩" && oldRadioColorBtn.id != "定制") setColorMode(ColorMode.CUSTOM);
			var command_code:String = "";
			var _value:Number = 0.0;
			switch(evt.info.code)
			{
				case "缩放":
					_scale = int(evt.info.data*100)/100;
					_value = _scale;
					zoomTxt.text = int(_scale * 100) + "%";
					command_code = NetStatusCommandCode.SET_SCALE;
					break;
				case "亮度":
					_brightness =  int(evt.info.data*1000)/1000;
					_value = _brightness;
					colorTxts[evt.info.code].text = int(_brightness*200-100)+"%";
					command_code = NetStatusCommandCode.SET_COLOR_BRIGHTNESS;
					break;
				case "对比度":
					_contrast =  int(evt.info.data*1000)/1000;
					_value = _contrast;
					colorTxts[evt.info.code].text = int(_contrast*200-100)+"%";
					command_code = NetStatusCommandCode.SET_COLOR_CONTRAST;
					break;
				case "饱和度":
					_saturation =  int(evt.info.data*1000)/1000;
					_value = _saturation;
					colorTxts[evt.info.code].text = int(_saturation*200-100)+"%";
					command_code = NetStatusCommandCode.SET_COLOR_SATURATION;
					break;
			}
			
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, 	{ code:command_code
					, level:NetStatusEventLevel.COMMAND
					, data:{ id:this.id, value:_value, action:evt.info.action}
					}
				)
			);
		}
		
		
		private var bg:PanelBg;
		private var tab_btns:Object;
		private var tabs:Object;
		private var views:Array;
		private var cur_tab:String;
		
		private var cancel_btn:LabelButton;
		private var default_btn:LabelButton;
		private var ok_btn:LabelButton;
		
		private var btn_normal_color:uint = 0x999999;
		private var btn_focused_color:uint = 0xCCCCCC;
		private var btn_pressed_color:uint = 0xCCCCCC;
		
		
		//播放设置相关
		private var default_allowFullScreenInteractive:Boolean = false;
		private var _allowFullScreenInteractive:Boolean;
		private var old_allowFullScreenInteractive:Boolean = default_allowFullScreenInteractive;
		
		private var default_hardwareAccelerate:Boolean = false;
		private var _hardwareAccelerate:Boolean;
		private var old_hardwareAccelerate:Boolean = default_hardwareAccelerate;
		
		private var _autoPlayNext:Boolean;
		
		private var lightMode:Array = [0.7, 0.6, 0.6];
		private var vividMode:Array = [0.5, 0.6, 0.4];
		private var theaterMode:Array = [0.55, 0.65, 0.6];
		private var defaultMode:Array = [0.5, 0.5, 0.5];
		
		private var default_proportion:String = ProportionMode.ORIGINAL;
		private var default_scale:Number = 1;
		private var default_rotationAngle:Number = 0;
		private var _proportion:String;
		private var _scale:Number;
		private var _rotationAngle:Number;
		private var old_proportion:String = default_proportion;
		private var old_scale:Number = default_scale;
		private var old_rotationAngle:Number = default_rotationAngle;
		
		
		private var default_mode:String = ColorMode.CUSTOM;
		private var default_brightness:Number = 0.5;
		private var default_contrast:Number = 0.5;
		private var default_saturation:Number = 0.5;
		private var _mode:String;
		private var _brightness:Number;
		private var _contrast:Number;
		private var _saturation:Number;
		private var old_mode:String = default_mode;
		private var old_brightness:Number = default_brightness;
		private var old_contrast:Number = default_contrast;
		private var old_saturation:Number = default_saturation;
		
		private var setParamsStatus:int = 0;
	}

}