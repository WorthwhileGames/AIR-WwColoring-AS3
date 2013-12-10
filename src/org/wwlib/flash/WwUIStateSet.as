package org.wwlib.flash
{
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwUIStateSet
	{
		public var id:String;
		
		private var __set:Dictionary;
		private var __activeState:WwUIState;
		
		public function WwUIStateSet(_id:String)
		{
			id = _id;
			__set = new Dictionary();
		}
		
		public function addState(state:WwUIState):void
		{
			if (state && state.id)
			{
				__set[state.id] = state;
			}
		}
		
		public function getState(_id:String):WwUIState
		{
			var state:WwUIState = __set[_id];
			__activeState = state;
			return state;
		}
		
		public function getFrameLabel():String
		{
			if (__activeState && __activeState.frameLabel)
			{
				return __activeState.frameLabel;
			}
			else
			{
				return "na";
			}
		}
	}
}