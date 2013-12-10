package org.wwlib.starling 
{
	import flash.events.Event;
	import starling.display.BlendMode;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwBrush extends WwSprite
	{
		
		private var __color:uint;
		private var __brushScale:Number = 1.0;
		
		public function WwBrush() 
		{
			
		}
		
		protected override function onImageLoaded(event:Event):void
		{
			super.onImageLoaded(event);
			
			__img.pivotX = __img.width / (2 * __scaleFactor);
            __img.pivotY = __img.height / (2 * __scaleFactor);
            __img.blendMode = BlendMode.NORMAL;
			__img.color = __color;
			
			__debug.msg("pivot: " + __img.pivotX + ", " + __img.pivotY);
		}
		
		public function setColor(_color:uint):void
		{
			__color = _color;
			if (__img != null)
			{
				__img.color = __color;
			}
		}
		
		public override function resetScale():void
		{
			__img.scaleX = __scaleFactor * __brushScale;
			__img.scaleY = __scaleFactor * __brushScale;
		}
		
		public function set brushScale(scale:Number):void
		{
			__brushScale = scale;
		}
		
	}
}