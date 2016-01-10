package com.tudou.player.skin.interfaces{
	import flash.events.IEventDispatcher;
	
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.skin.widgets.Widget;
	
	/**
	 * IControlArea
	 */
	public interface IControlArea extends IEventDispatcher{
		//
		function get width():Number; function set width(value:Number):void;
		function get height():Number; function set height(value:Number):void;
		function get autoHide():Boolean; function set autoHide(value:Boolean):void;
		function get autoHideTimeout():int; function set autoHideTimeout(value:int):void;
		
		//
		function configure(xml:XML, assetManager:AssetsManager):void;
		function getWidget(id:String):Widget
	}
}