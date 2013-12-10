package org.wwlib.utils 
{
	/**
	 * Adapted from ctp2nd on http://forum.starling-framework.org/topic/detect-device-modelperformance
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */

	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwDeviceInfo 
	{
		private static var __instance:WwDeviceInfo;

		public static const isDebugger:Boolean = Capabilities.isDebugger;
		public static const isLandscape:Boolean = true;
		public static const debuggerDevice:String = "debugger_1024x768";
		//public static const debuggerDevice:String = "debugger_960x640";
		//public static const debuggerDevice:String = "debugger_480x320";
		//public static const debuggerDevice:String = "debugger_1136x640";
		//public static const debuggerDevice:String = "debugger_2048x1536";
 		
		public var os:String;
		public var devString:String;
		public var device:String;
		
		public var stageX:Number;  //Background Top-Left
		public var stageY:Number;
		public var stageWidth:Number;
		public var stageHeight:Number;
		public var stageCenterX:Number;
		public var stageCenterY:Number;
		public var canvasX:Number;  //Canvas  Top-Left
		public var canvasY:Number;
		public var canvasWidth:Number;
		public var canvasHeight:Number;
		public var starlingViewPort:Rectangle;
		public var assetScaleFactor:Number;  //relative to base 960x640 canvas target
		
		public var resolutionX:Number;  //as reported by Capabilities
		public var resolutionY:Number;
		public var isDebugger:Boolean;
		public var screenDPI:Number;
		
		public var debuggerX:Number;
		public var debuggerY:Number;


		public function WwDeviceInfo(enforcer:SingletonEnforcer)
		{
			if (!(enforcer is SingletonEnforcer))
			{
				throw new ArgumentError("WwDeviceInfo cannot be directly instantiated!");
			}
		}
 
		/**
		*   Initialize the singleton if it has not already been initialized
		*   @return The singleton instance
		*/
		public static function init(): WwDeviceInfo
		{
			if (__instance == null)
			{
				__instance = new WwDeviceInfo(new SingletonEnforcer());
				__instance.getDeviceDetails();
			}

			return __instance;
		}

		/**
		*   Get the singleton instance
		*   @return The singleton instance or null if it has not yet been
		*           initialized
		*/
		public static function get instance(): WwDeviceInfo
		{
			return __instance;
		}

		public function getDeviceDetails():void {

			this.os = Capabilities.os;
			var devStr:String = this.os;
			var devStrArr:Array = devStr.split(" ");
			devStr = devStrArr.pop();
			devStr = (devStr.indexOf(",") > -1)?devStr.split(",").shift():debuggerDevice;
			this.devString = devStr;

			this.resolutionX = Capabilities.screenResolutionX;
			this.resolutionY = Capabilities.screenResolutionY;
			this.isDebugger = Capabilities.isDebugger;
			this.screenDPI = Capabilities.screenDPI;

			if ((devStr == "iPhone1") || (devStr == "iPhone2") || (devStr == "debugger_480x320")){
				// lowdef iphone, 3, 3g, 3gs, 4
				this.stageX = -16;
				this.stageY = -32;
				this.stageWidth = 480;
				this.stageHeight = 320;
				this.starlingViewPort = new Rectangle(0, 0, stageWidth, stageHeight);
				this.stageCenterX = 240;
				this.stageCenterY = 160;
				this.canvasX = 0;
				this.canvasY = 0;
				this.canvasWidth = 480;
				this.canvasHeight = 320;
				this.device = "iphone";
				this.assetScaleFactor = 0.5;

			} else if ((devStr == "iPhone3") || (devStr == "iPhone4")  || (devStr == "debugger_960x640")){
				// highdef iphone 4s, 5?
				this.stageX = -32;
				this.stageY = -64;
				this.stageWidth = 960;
				this.stageHeight = 640;
				this.stageCenterX = 480;
				this.stageCenterY = 320;
				this.canvasX = 0;
				this.canvasY = 0;
				this.canvasWidth = 960;
				this.canvasHeight = 640;
				this.starlingViewPort = new Rectangle(0, 0, stageWidth, stageHeight);
				this.device = "iphoneRetina";
				this.assetScaleFactor = 1.0;

			} else if ((devStr == "iPhone5") || (devStr == "debugger_1136x640")){
				// highdef iphone 4s, 5?
				this.stageX = 56;
				this.stageY = -64;
				this.stageWidth = 1136;
				this.stageHeight = 640;
				this.stageCenterX = 568;
				this.stageCenterY = 320;
				this.canvasX = 88;
				this.canvasY = 0;
				this.canvasWidth = 960;
				this.canvasHeight = 640;
				this.starlingViewPort = new Rectangle(0, 0, stageWidth, stageHeight);
				this.device = "iphone5";
				this.assetScaleFactor = 1.0;
				
			} else if ((devStr == "iPad1") || (devStr == "iPad2") || (devStr == "debugger_1024x768")){
				// ipad 1,2
				this.stageX = 0;
				this.stageY = 0;
				this.stageWidth = 1024;
				this.stageHeight = 768;
				this.stageCenterX = 512;
				this.stageCenterY = 384;
				this.canvasX = 32;
				this.canvasY = 64;
				this.canvasWidth = 960;
				this.canvasHeight = 640;
				this.starlingViewPort = new Rectangle(0, 0, stageWidth, stageHeight);
				this.device = "ipad";
				this.assetScaleFactor = 1.0;

			} else if ((devStr == "iPad3")){
				this.stageX = 0;
				this.stageY = 0;
				this.stageWidth = 2048;
				this.stageHeight = 1536;
				this.stageCenterX = 1024;
				this.stageCenterY = 768;
				this.canvasX = 64;
				this.canvasY = 128;
				this.canvasWidth = 1920;
				this.canvasHeight = 1280;
				this.starlingViewPort = new Rectangle(0, 0, stageWidth, stageHeight);
				this.device = "ipadRetina";
				this.assetScaleFactor = 2.0;
			} else if ((devStr == "iPad4") || (devStr == "debugger_2048x1536")){
				this.stageX = 0;
				this.stageY = 0;
				this.stageWidth = 2048;
				this.stageHeight = 1536;
				this.stageCenterX = 1024;
				this.stageCenterY = 768;
				this.canvasX = 64;
				this.canvasY = 128;
				this.canvasWidth = 1920;
				this.canvasHeight = 1280;
				this.starlingViewPort = new Rectangle(0, 0, stageWidth, stageHeight);
				this.device = "ipadRetina";
				this.assetScaleFactor = 2.0;
			} else {
				this.stageX = 0;
				this.stageY = 0;
				this.stageWidth = 1024;
				this.stageHeight = 768;
				this.stageCenterX = 512;
				this.stageCenterY = 384;
				this.canvasX = 32;
				this.canvasY = 64;
				this.canvasWidth = 960;
				this.canvasHeight = 640;
				this.starlingViewPort = new Rectangle(0, 0, stageWidth, stageHeight);
				this.device = WwDeviceInfo.debuggerDevice;
				this.assetScaleFactor = 1.0;
			}
			
			this.debuggerX = 1024 + (this.stageX / this.assetScaleFactor * 1) + 1; // +1 to eliminated hairline reveal on right edge of screen
			this.debuggerY = 10 + (this.stageY / this.assetScaleFactor * -1);
		}
	}
}

/** A class that is here specifically to stop public instantiation of the
*   WwDebug singleton. It is inaccessible by classes outside this file. */
class SingletonEnforcer{}