package com.tudou.player.skin.widgets 
{
	import com.tudou.layout.LayoutSprite;
	import flash.system.ApplicationDomain;
	/**
	 * 有背景图片的布局元素
	 * 
	 * @author 8088
	 */
	public class HasBgImgLayoutSprite extends LayoutSprite
	{
		override protected function getDefinitionByName(url:String):Object
		{
			return ApplicationDomain.currentDomain.getDefinition(url);
		}
	}

}