package org.wwlib.flash
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwUIState
	{
		
		public var id:String;
		public var frameLabel:String;
		public var setupFunction:Function;
		public var cleanupFunction:Function;
		public var elementDictionary:Dictionary;
		
		
		public function WwUIState(_id:String)
		{
			id = _id;
			elementDictionary = new Dictionary();
		}
		
		public function addText(name:String, text:String):WwUIStateText
		{
			var txt:WwUIStateText = new WwUIStateText(name, text);
			elementDictionary[name] = txt;
			
			return txt;
		}
		
		public function addImage(name:String, bmd:BitmapData):WwUIStateImage
		{
			var image:WwUIStateImage = new WwUIStateImage(name, bmd);
			elementDictionary[name] = image;
			
			return image;
		}
		
		public function addButton(name:String, handler:Function):WwUIStateButton
		{
			var button:WwUIStateButton = new WwUIStateButton(name, handler);
			elementDictionary[name] = button;
			
			return button;
		}
		
		public function getElement(name:String):WwUIStateElement
		{
			return elementDictionary[name];
		}
		
	}
}