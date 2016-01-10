/*修改为新主题包名*/
var theme = 'tdtv';

var doc = fl.getDocumentDOM();
var lib = doc.library;
var items = lib.items;
var num = 0;

fl.outputPanel.clear();
for(var i = 0; i < items.length; i++)
{
	var type = items[i].itemType;
	var name = items[i].name.substring(items[i].name.lastIndexOf('/')+1);
	var className = items[i].linkageClassName;
	if(String(className).indexOf('com.tudou.player.skin.themes')!=-1)
	{
		items[i].linkageClassName = 'com.tudou.player.skin.themes.'+theme+'.'+name;
		fl.trace(items[i].linkageClassName);
		num++
	}
	
}
fl.trace("共计修改"+num+"项");