package com.tudou.player.skin.widgets
{
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	public class Previewer extends Sprite
	{
		private static var instance:Previewer;
		//传入的值
		private var maxPics:int;
		private var step:int;
		private var imagePathArray:Array;
		
		private var imageLoaderArray:Array;
		private var imageLoaderDict:Dictionary;
		private var lastPicIndex:int;
		
		private var _isFirstShow:Boolean = true;
		private var _direction:String;
		
		private var card:Card;
		private var bitmapWidth:Number = 128;
		private var bitmapHeight:Number = 72;
		
		private static const LOADER_STATE_READY:String = "Loader_state_ready";
		private static const LOADER_STATE_LOADING:String = "Loader_state_loading";
		private static const LOADER_STATE_LOADED:String = "Loader_state_loaded";
		private static const LOADER_STATE_LOAD_ERROR:String = "Loader_state_load_error";
		private static const LOADER_STATE_PRELOAD:String = "Loader_state_preload";
		private static const DIRECTION_NONE:String = "direction_none";
		private static const DIRECTION_LEFT:String = "direction_left";
		private static const DIRECTION_RIGHT:String = "direction_right";
		
		public function Previewer()
		{
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, bitmapWidth, bitmapHeight+5);
			this.graphics.endFill();
			buttonMode = true;
		}
		
		public static function getInstance():Previewer
		{
			if(instance == null) instance = new Previewer();
			return instance;
		}
		
		/**
		 * 启动快眼预览
		 * @param	quickpic	服务端传过来的数据对象，包含所有大图地址，大图的规格，步长等数据
		 */
		public function boot(quickpic:Object):void
		{
			var str:String = quickpic.standard || '10x10';
			var standard:Array = str.split('x');
			if (standard.length != 2)
			{
				standard = [10, 10];
			}
			else
			{
				for (var i:int = 0; i < standard.length; i++)
				{
					standard[i] = int(standard[i])
				}
			}
			maxPics = standard[0] * standard[1];
			step = int(quickpic.step || '6');
			imagePathArray = quickpic.pics || null;
			
			//初始化
			init();
			visible = true;
		}
		
		/**
		 * 设置当前播放头，根据播放头，显示相应的预览
		 * @param	pt 播放头
		 * @return 返回是否已经加载好大图
		 * 
		 */
		public function setPlaytime(pt:int):Boolean
		{
			try
			{
				if (!imagePathArray || imagePathArray.length == 0)
				{
					return false;
				}
				
				//获取图片的索引
				var index:int = getNumberFormTime(pt);
				if (index != lastPicIndex)
				{
					if (_isFirstShow == true)
					{
						_direction = DIRECTION_NONE;
					}
					else
					{
						if (index > lastPicIndex)
						{
							_direction = DIRECTION_RIGHT;
						}
						if (index < lastPicIndex)
						{
							_direction = DIRECTION_LEFT;
						}
						if (index == lastPicIndex)
						{
							_direction = DIRECTION_NONE;
						}
					}
					loadImage(index);
					renderImageArray(index);
					lastPicIndex = index;
					_isFirstShow = false;
				}
				
				var page:int = getPosition(index).n;
				var loader:Loader = imageLoaderArray[page] as Loader;
				var state:String = imageLoaderDict[loader];
				if(state == LOADER_STATE_LOADED)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			catch (e:Error)
			{
				trace("setPlaytime error!!! ", e.message, e.errorID, e.name);
				return false;
			}
			
			return false;
		}
		
		/**
		 * 获取当前图片的对应的播放时间点 
		 * @return 播放时间点 单位秒
		 */		 
		public function getPlaytime():int
		{
			if(lastPicIndex >= 0)
				return (lastPicIndex+1) * step;
			else
				return 0;
		}
		
		/**
		 * 摧毁快眼预览
		 */
		public function destroy():void
		{
			if(imageLoaderArray)
			{
				var loader:Loader;
				var state:String;
				for (var i:int = 0; i < imageLoaderArray.length; i++)
				{
					loader = imageLoaderArray[i] as Loader;
					state = imageLoaderDict[loader];
					if (state == LOADER_STATE_LOADING) //若正在加载
					{
						loader.unload();
						loader.unloadAndStop();
						loader.close();
					}
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
					loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onImageLoadError);
					loader = null;
				}
			}
			imageLoaderArray = null;
			imageLoaderDict = null;
			lastPicIndex = -1;
			visible = false;
		}
		
		override public function get width():Number
		{
			if (!visible)
				return 0;
			else
				return super.width;
		}
		
		override public function get height():Number
		{
			if (!visible)
				return 0;
			else
				return super.height;
		}
		
		/**
		 * 初始化loader以及显示card
		 */
		private function init():void
		{
			//初始化变量
			imageLoaderDict = new Dictionary();
			imageLoaderArray = [];
			lastPicIndex = -1;
			
			//初始化card
			card = new Card();
			card.init(bitmapWidth, bitmapHeight);
			addChild(card);
			
			var loader:Loader;
			var index:int = 0;
			while (index < imagePathArray.length)
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onImageLoadError);
				imageLoaderArray.push(loader);
				imageLoaderDict[loader] = LOADER_STATE_READY;
				index++;
			}
		}
		
		private function onImageLoadError(event:Event):void
		{
			var loader:Loader = event.target.loader as Loader;
			imageLoaderDict[loader] = LOADER_STATE_LOAD_ERROR;
			renderImageArray(lastPicIndex);
			
			var url:String = "";
			var index:int = imageLoaderArray.indexOf(loader);
			if(index>=0) 
				url = imagePathArray[index];
			else url = "";
			
			dispatchEvent(new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:SkinNetStatusEventCode.SCRUBBAR_PREVIEWER_LOAD_FAILED, value:url }
							)
						 );
		}
		
		private function onImageLoaded(event:Event):void
		{
			var loader:Loader = event.target.loader as Loader;
			imageLoaderDict[loader] = LOADER_STATE_LOADED;
			renderImageArray(lastPicIndex);
			
			dispatchEvent(new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:SkinNetStatusEventCode.SCRUBBAR_PREVIEWER_LOAD_COMPLETE }
							)
						 );
		}
		
		private function loadImage(index:int):void
		{
			var loaderContext:LoaderContext;
			var page:int = getPosition(index).n;
			var loader:Loader = imageLoaderArray[page] as Loader;
			var state:String = imageLoaderDict[loader];
			//优先加载所需的大图
			if (state == LOADER_STATE_READY || state == LOADER_STATE_PRELOAD)
			{
				loaderContext = new LoaderContext(true);
				loader.load(new URLRequest(imagePathArray[page] as String), loaderContext);
				imageLoaderDict[loader] = LOADER_STATE_LOADING;
			}
			//预加载其他两张大图
			switch (_direction)
			{
				case DIRECTION_NONE: 
					changeStateToPreload([page - 1, page + 1]);
					break;
				case DIRECTION_RIGHT: 
					changeStateToPreload([page + 1, page + 2]);
					break;
				case DIRECTION_LEFT: 
					changeStateToPreload([page - 1, page - 2]);
					break;
				default: 
					break;
			}
			preloadImage();
		}
		
		private function changeStateToPreload(indexArr:Array):void
		{
			var page:int = 0;
			var loader:Loader;
			var state:String;
			var n:int = 0;
			while (n < indexArr.length)
			{
				
				page = indexArr[n];
				page = page > 0 ? page : page;
				page = page < (imageLoaderArray.length - 1) ? page : imageLoaderArray.length - 1;
				loader = imageLoaderArray[page] as Loader;
				state = imageLoaderDict[loader];
				if (state == LOADER_STATE_READY)
				{
					imageLoaderDict[loader] = LOADER_STATE_PRELOAD;
				}
				n++;
			}
		}
		
		private function preloadImage():void
		{
			var loader:Loader;
			var state:String;
			var loaderContext:LoaderContext;
			var n:int = 0;
			while (n < imageLoaderArray.length)
			{
				
				loader = imageLoaderArray[n] as Loader;
				state = imageLoaderDict[loader];
				if (state == LOADER_STATE_PRELOAD)
				{
					loaderContext = new LoaderContext(true);
					loader.load(new URLRequest(imagePathArray[n] as String), loaderContext);
					imageLoaderDict[loader] = LOADER_STATE_LOADING;
				}
				n++;
			}
		}
		
		private function renderImageArray(picIndex:int):void
		{
			var position:Object;
			position = getPosition(picIndex);
			updateCard(position);
		}
		
		private function updateCard(position:Object):void
		{
			var loader:Loader = imageLoaderArray[position.n] as Loader;
			var state:String = imageLoaderDict[loader];
			switch (state)
			{
				case LOADER_STATE_LOADED: 
					renderBitmap(position, card.bitmapData);
					break;
				case LOADER_STATE_LOAD_ERROR: 
					card.setError();
					break;
				case LOADER_STATE_READY: 
				case LOADER_STATE_LOADING: 
				case LOADER_STATE_PRELOAD: 
					card.setLoading();
					break;
				default: 
					break;
			}
		}
		
		private function renderBitmap(position:Object, btmd:BitmapData):void
		{
			var loader:Loader;
			var displayObject:DisplayObject;
			var matrix:Matrix;
			try
			{
				loader = imageLoaderArray[position.n] as Loader;
				displayObject = loader.content as DisplayObject;
				matrix = new Matrix(1, 0, 0, 1, (-bitmapWidth) * position.x, (-bitmapHeight) * position.y);
				btmd.draw(displayObject, matrix);
			}
			catch (error:Error)
			{
			}
		}
		
		/**
		 * 根据时间获取其对应的图片索引
		 * @param	t	playtime播放时间
		 * @return		图片索引
		 */
		private function getNumberFormTime(t:int):int
		{
			var num:int = t;
			num = Math.round(num / step) - 1;
			num = num > 0 ? num : 0;
			num = num < imageLoaderArray.length * maxPics ? num : (imageLoaderArray.length * maxPics);
			return num;
		}
		
		/**
		 * 根据图片索引获取该图片的位置信息
		 * @param	num	图片索引
		 * @return		{n:第几张, x:第几列, y:第几行}
		 */
		private function getPosition(num:int):Object
		{
			var nn:int = num;
			nn = nn > 0 ? nn : 0;
			nn = nn < imageLoaderArray.length * maxPics ? nn : (imageLoaderArray.length * maxPics);
			var page:int = Math.floor(nn / maxPics);
			var column:int = Math.floor(nn % maxPics % 10);
			var row:int = Math.floor(nn % maxPics / 10);
			return {n: page, x: column, y: row};
		}
	
	}

}
import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;

class Card extends flash.display.Sprite
{
	private var _bitmapData:flash.display.BitmapData;
	private var _bitmap:Bitmap;
	private var _stateText:TextField;
	private var _textBg:flash.display.Sprite;
	
	public function Card()
	{
	}
	
	public function init(ww:Number, hh:Number):void
	{
		_bitmapData = new flash.display.BitmapData(ww, hh, false, 0);
		_bitmap = new Bitmap(_bitmapData);
		_bitmap.smoothing = true;
		addChild(_bitmap);
		_textBg = new flash.display.Sprite();
		_textBg.graphics.beginFill(0);
		_textBg.graphics.drawRect(0, 0, ww, hh);
		_textBg.graphics.endFill();
		_textBg.visible = false;
		addChild(_textBg);
		_stateText = new TextField();
		_stateText.defaultTextFormat = new TextFormat("Arial", 12, 16777215);
		_stateText.autoSize = TextFieldAutoSize.CENTER;
		_stateText.width = 100;
		_stateText.height = 20;
		_stateText.selectable = false;
		_stateText.x = (ww - _stateText.width) / 2;
		_stateText.y = (hh - _stateText.height) / 2;
		_stateText.visible = false;
		addChild(_stateText);
	}
	
	public function setError():void
	{
		_textBg.visible = true;
		_stateText.visible = true;
		_stateText.text = "预览加载失败";
	}
	
	public function setLoading():void
	{
		_textBg.visible = true;
		_stateText.visible = true;
		_stateText.text = "加载中";
	}
	
	public function get bitmapData():flash.display.BitmapData
	{
		_textBg.visible = false;
		_stateText.visible = false;
		return _bitmapData;
	}

}