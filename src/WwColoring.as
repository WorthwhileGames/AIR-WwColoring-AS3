package 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import org.wwlib.WwColoring.anim.StageOuterBlocker;
	import org.wwlib.flash.WwAlertsManager;
	import org.wwlib.flash.WwAppBG;
	import org.wwlib.starling.WwSprite;
	import org.wwlib.utils.WwDebug;
	import org.wwlib.utils.WwDeviceInfo;
	import org.wwlib.utils.WwGoViral;
	
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	[SWF(backgroundColor="#FFFFFF", width="1024", height="768", frameRate="59")]
	public class WwColoring extends Sprite
	{
		private var mStarling:Starling;
		
		private var __debug:WwDebug;
		private var __deviceInfo:WwDeviceInfo;
		private var __appFlashStage:MovieClip;
		private var __appFlashAlertsStage:MovieClip;
		private var __appDebugStage:MovieClip;
		
		public static var appStage:Stage;
		public static var stageOuterBlocker:StageOuterBlocker;
		
		/** Embedded the default app image for immediate display. */
		[Embed(source="/Default-Landscape.png")]
		private var defaultAppImageClass:Class;
		private var defaultAppBitmap:Bitmap;
		
		public function WwColoring()
		{
			appStage = stage;
			appStage.color = 0xFFFFFF;
			appStage.scaleMode = StageScaleMode.NO_SCALE;
			appStage.align = StageAlign.TOP_LEFT;
			
			// Note: So far, blocking MOUSE_DOWN propagation to starling doesn't work on the device
			// Starling listens for its own TOUCH events
			// appStage.addEventListener(MouseEvent.MOUSE_DOWN, onPropagationHandler);
			
			//Coloring uses a __uiActive flag to determine when touches should be drawn
			
			__appFlashStage = new MovieClip();
			__appFlashAlertsStage = new MovieClip();
			__appDebugStage = new MovieClip();
			
			stage.addChild(__appFlashStage);
			stage.addChild(__appFlashAlertsStage);
			stage.addChild(__appDebugStage);
			
			defaultAppBitmap = new defaultAppImageClass() as Bitmap;
			WwAppBG.init(__appFlashStage, defaultAppBitmap);
			WwAppBG.show();
			
			stageOuterBlocker = new StageOuterBlocker();
			stageOuterBlocker.mouseChildren = false;
			stageOuterBlocker.mouseEnabled = false;
			__appDebugStage.addChild(stageOuterBlocker);
			
			__deviceInfo = WwDeviceInfo.init();
			WwDebug.init(__appDebugStage);
			__debug = WwDebug.instance;
			
			
			
			__debug.msg("os: " + __deviceInfo.os,"3");
			__debug.msg("devStr: " + __deviceInfo.devString,"3");
			__debug.msg("device: " + __deviceInfo.device,"3");
			__debug.msg("bgX: " + __deviceInfo.stageX,"3");
			__debug.msg("bgY: " + __deviceInfo.stageY,"3");
			__debug.msg("bgWidth: " + __deviceInfo.stageWidth,"3");
			__debug.msg("bgHeight: " + __deviceInfo.stageHeight,"3");
			__debug.msg("canvasX: " + __deviceInfo.canvasX,"3");
			__debug.msg("canvasY: " + __deviceInfo.canvasY,"3");
			__debug.msg("resolutionX: " + __deviceInfo.resolutionX,"3");
			__debug.msg("resolutionY: " + __deviceInfo.resolutionY,"3");
			__debug.msg("isDebugger: " + __deviceInfo.isDebugger,"3");
			__debug.msg("screenDPI: " + __deviceInfo.screenDPI,"3");			
			__debug.show = true;
			
			WwSprite.FLASH_STAGE = __appFlashStage;
			WwSprite.FLASH_STAGE.scaleX =  __deviceInfo.assetScaleFactor;
			WwSprite.FLASH_STAGE.scaleY =  __deviceInfo.assetScaleFactor;
			WwSprite.FLASH_STAGE.x =  __deviceInfo.stageX;
			WwSprite.FLASH_STAGE.y =  __deviceInfo.stageY;
			
			__appFlashAlertsStage.scaleX =  __deviceInfo.assetScaleFactor;
			__appFlashAlertsStage.scaleY =  __deviceInfo.assetScaleFactor;
			__appFlashAlertsStage.x =  __deviceInfo.stageX;
			__appFlashAlertsStage.y =  __deviceInfo.stageY;
			
			__appDebugStage.scaleX =  __deviceInfo.assetScaleFactor;
			__appDebugStage.scaleY =  __deviceInfo.assetScaleFactor;
			__appDebugStage.x =  __deviceInfo.stageX;
			__appDebugStage.y =  __deviceInfo.stageY;
			
			WwSprite.__baseScaleFactor = __deviceInfo.assetScaleFactor;
			__debug.msg("assetScaleFactor: " + __deviceInfo.assetScaleFactor,"3");
			
			WwGoViral.init();
			WwAlertsManager.init(__appFlashAlertsStage);
			
			Starling.multitouchEnabled = true; // useful on mobile devices
			Starling.handleLostContext = true; // deactivate on mobile devices (to save memory)
			
			mStarling = new Starling(Game, stage, __deviceInfo.starlingViewPort);
			Starling.current.stage.stageWidth  = __deviceInfo.stageWidth;
			Starling.current.stage.stageHeight = __deviceInfo.stageHeight;
			
			__debug.msg("Starling.current.stage.stageWidth: " + Starling.current.stage.stageWidth,"3");
			__debug.msg("Starling.current.stage.stageWidth: " + Starling.current.stage.stageHeight,"3");
			__debug.msg("Starling.current.contentScaleFactor: " + Starling.current.contentScaleFactor,"3");
			
			mStarling.simulateMultitouch = true;
			mStarling.enableErrorChecking = Capabilities.isDebugger;
			mStarling.start();
			
			// this event is dispatched when stage3D is set up
			mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			
			//mStarling.showStats = true;
			
		}
		
		private function onContextCreated(event:Event):void
		{
			// set framerate to 30 in software mode
			
			if (Starling.context.driverInfo.toLowerCase().indexOf("software") != -1)
				Starling.current.nativeStage.frameRate = 30;
		}
	}
}