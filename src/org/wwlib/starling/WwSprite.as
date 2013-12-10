package org.wwlib.starling 
{
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	
	import org.wwlib.utils.WwDebug;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * Adds image loading, crude debugging and other generally useful functionality...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwSprite extends Sprite
	{
		public static var __baseScaleFactor:Number = 0.5;
		public static var FLASH_STAGE:flash.display.MovieClip;
		
		protected var __img:Image;
		protected var __x:int;
		protected var __y:int;
		protected var __bmp:Bitmap;
		protected var __debug:WwDebug = WwDebug.instance;
		protected var __scaleFactor:Number = WwSprite.__baseScaleFactor;
		protected var __url:String;
		
		protected var __onReadyCallback:Function;
		
		public function WwSprite() 
		{

		}
		
		public function loadImage(url:String):void
		{
			__url = url;
			if ((__url != null) && (__url != ""))
			{
				// create a LoaderContext
				var loaderContext:LoaderContext = new LoaderContext();
				// specify async decoding
				loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
				// create a Loader
				var loader:Loader = new Loader();
				// inform the Loader
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoaded);
				loader.load( new URLRequest(url), loaderContext );
			}
			else
			{
				onReady();
			}
		}
		
		protected function onImageLoaded(event:Event):void
		{
			//__debug.msg("onImageLoaded: "+ __url);
			__bmp = event.target.content as Bitmap;
			removeChild(__img);
			__img = Image.fromBitmap(__bmp);
			resetScale();
			//__img.alpha = 0.5;
			addChild(__img);
			__bmp = null;
			onReady();
		}
		
		public function resetScale():void
		{
			__img.scaleX = __scaleFactor;
			__img.scaleY = __scaleFactor;
		}
		
		// Override this
		public function onReady():void
		{
			//__debug.msg("onReady: " + __url);
			if (__onReadyCallback != null)
			{
				__onReadyCallback(__url);
			}
		}

		public function get image():Image
		{
			return __img;
		}
		
		public function get url():String
		{
			return __url;
		}
		
		public function set onReadyCallback(f:Function):void
		{
			__onReadyCallback = f;
		}
		
		public override function dispose():void
		{
			removeChild(__img);
			__img = null;
			super.dispose();
		}
	}

}