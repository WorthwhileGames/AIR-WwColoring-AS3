package org.wwlib.flash
{
	import flash.display.BitmapData;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwUIStateImage extends WwUIStateElement
	{
		public var bitmapData:BitmapData;
		
		public function WwUIStateImage(_name:String, _bmd:BitmapData)
		{
			super(_name);
			bitmapData = _bmd;
		}
	}
}