package org.wwlib.flash
{

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwUIStateButton extends WwUIStateElement
	{
		public var handler:Function;
		public var label:String;
		
		public function WwUIStateButton(_name:String, _func:Function, _label="")
		{
			super(_name);
			handler = _func;
			label = _label;
		}
	}
}