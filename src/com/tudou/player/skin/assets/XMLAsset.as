package com.tudou.player.skin.assets 
{
	import flash.utils.ByteArray;
	
	public class XMLAsset 
	{
		
		public function XMLAsset(asset:Class)
        {
            if ( asset != null )
            {
                _xml = createXML( asset );
            }
		}
		
		public function get xml():XML
        {
            return _xml;
        }
		
		public static function createXML(asset:Class):XML
        {
            var bya:ByteArray = ByteArray(new asset());
            var source:String = bya.readUTFBytes(bya.length);
			
            try {
                var xml:XML = new XML(source);
            }
            catch(error:Error)
            {
                throw new Error("Class 必须是包含嵌入XML文档的有效标记。" + error.message);
            }
            return xml;
        }
		
		protected var _xml:XML;
	}

}