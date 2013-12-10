package org.wwlib.flash
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAppBG
	{
		
		public static var bg:Bitmap;
		public static var stage:MovieClip;
		public static var bg_visible:Boolean = false;
		
		public static function init(_stage:MovieClip, _bg:Bitmap):void
		{
			stage = _stage;
			bg = _bg;
		}
		
		public static function show():void
		{
			stage.addChild(bg);
			bg_visible = true;
		}
		
		public static function hide():void
		{
			if (bg_visible)
			{
				stage.removeChild(bg);
				bg_visible = false;
			}
		}
	}
}