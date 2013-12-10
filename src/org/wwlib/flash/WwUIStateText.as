package org.wwlib.flash
{
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwUIStateText extends WwUIStateElement
	{
		public var text:String;
		
		public function WwUIStateText(_name:String, _text:String)
		{
			super(_name);
			text = _text;
		}
	}
}