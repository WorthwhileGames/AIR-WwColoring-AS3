package org.wwlib.starling
{
	import org.wwlib.WwColoring.anim.UI_ColoringFrame;
	import org.wwlib.WwColoring.anim.UI_ColoringMenu;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.wwlib.flash.WwColoringMenuController;
	import org.wwlib.utils.WwDeviceInfo;
	import org.wwlib.flash.WwAlertsManager;
	import org.wwlib.utils.WwGoViral;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.utils.Color;
	import starling.utils.deg2rad;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
    public class WwColoringScene extends WwScene
    {
        private var mRenderTexture:RenderTexture;
        private var mCanvas:Image;
        private var mBrush:WwBrush;
        private var mColors:Dictionary;
		
		
		private var __activeColor:uint;
		private var __rotateBrush:Boolean = true;
		private var __brushBehavior:String;
		private var __brushDynamicColor:String;
		
		private var __scalevar:Number = 0;
		private var __colorvar:Number = 0;
		
		private var __rainbowvar:Number = 0;
		private var __red:Number = 0;
		private var __green:Number = 0;
		private var __blue:Number = 0;
		private var __offset1:Number = 0;
		private var __offset2:Number = ((2 * Math.PI) / 3);
		private var __offset3:Number = ((4 * Math.PI) / 3);
		private var __frequency:Number = 0;
		private var __amplitude:Number = 0;
		private var __center:Number = 0;
		
		private var __prevx:Number=0;
		private var __prevy:Number = 0;
		
		private var __dashinterval:Number = 0;
		private var __dashvar:Number = 0;
		
		private var __dashinterval2:Number = 0;
		private var __dashvar2:Number = 0;
		
		private var __expandscale:Number = 0;
		
		private var __blendmode:String;
		
		private var __coloringWrapper:WwSprite;
		private var __coloringWrapperOffsetX:Number;
		private var __coloringPage:WwSprite;
		private var __coloringPageBG:WwSprite;
		
		private var __drawingEvent:TouchEvent
		
		private var __UI_ColoringFrame:UI_ColoringFrame;
		private var __UI_ColoringMenu:UI_ColoringMenu;
		private var __ColoringMenuController:WwColoringMenuController;
		private var __UI_ColoringPageBitmap:Bitmap;
		
		private var __uiActive:Boolean;
		
		
        
        public function WwColoringScene(scene_manager:WwSceneManager)
        {
			super(scene_manager);
			
			WwSprite.FLASH_STAGE.parent.addEventListener(MouseEvent.MOUSE_UP, onGlobalMouseUp);
			
			// Note: blocking propagation to Starling is accomplished using the uiActive flag
			uiActive = false;
        }
		
		public function onGlobalMouseUp(e:Event):void
		{
			if (__ColoringMenuController)
			{
				__ColoringMenuController.onGlobalMouseUp(e);
			}
			uiActive = false;
		}
		
		public override function initWithXML(xml:XML):void
		{
			//super.initWithXML(xml);
			
			__UI_ColoringPageBitmap = new Bitmap();
			__UI_ColoringPageBitmap.visible = false;
			WwSprite.FLASH_STAGE.addChild(__UI_ColoringPageBitmap);
			
			__UI_ColoringMenu = new UI_ColoringMenu();
			WwSprite.FLASH_STAGE.addChild(__UI_ColoringMenu);
			__UI_ColoringMenu.x = 832;
			__UI_ColoringMenu.y = 64;
			__ColoringMenuController = new WwColoringMenuController(this, __UI_ColoringMenu);
			
			
			__UI_ColoringFrame = new UI_ColoringFrame();
			__UI_ColoringFrame.logo.visible = false;
			WwSprite.FLASH_STAGE.addChild(__UI_ColoringFrame);
			var frame_mc:flash.display.MovieClip = __UI_ColoringFrame["frame"];
			__UI_ColoringFrame.mouseChildren = false;
			__UI_ColoringFrame.mouseEnabled = false;
			__UI_ColoringFrame.visible = true;
			//Starling.current.showStats = true;
			
			
			var xml_xtra:XML = xml.xtra[0];
			try 
			{
				if (xml_xtra != null)
				{
					__coloringWrapper = new WwSprite();
					__coloringWrapperOffsetX = 0;

					addChild(__coloringWrapper);
										
					mColors = new Dictionary();
					mRenderTexture = new RenderTexture(WwDeviceInfo.instance.canvasWidth, WwDeviceInfo.instance.canvasHeight);
					
					mCanvas = new Image(mRenderTexture);
					__coloringWrapper.addChild(mCanvas);
					
					__coloringPage = new WwSprite();
					__coloringPage.addEventListener(TouchEvent.TOUCH, onTouch);
					__coloringWrapper.addChild(__coloringPage);
					__coloringPage.onReadyCallback = onColoringPageReady;
				
					__ColoringMenuController.show(false);
					__coloringWrapper.visible = false;
					
					page = xml_xtra.@clrPg;
					
					brushColorFromString = xml_xtra.@defaultColor;
					
					var _brush:WwBrush = new WwBrush();
					_brush.loadImage(xml_xtra.@defaultBrush);
					brush = _brush;
				}
			}
			catch (err:Error)
			{
				__debug.msg("initWithXML: Coloring: Error: " + err, "3");
			}
		}
		
		public function onColoringPageReady(url:String):void
		{
			this.stage.color = 0xFFFFFF;
			__ColoringMenuController.show();
			__coloringWrapper.visible = true;
			__ColoringMenuController.showTools();
			__debug.msg("onColoringPageReady: " + url + ", __coloringWrapper.x: " + __coloringWrapper.x, "1");
			
			__UI_ColoringFrame.gotoAndPlay("a");
		}
		
		override public function enterframeEvent(elapsed_time:int, total_seconds:Number):void
		{
			__ColoringMenuController.enterFrameUpdateHandler(elapsed_time, total_seconds);
		}
		
		public function onAvatarUIComplete():void
		{
			__ColoringMenuController.show();
			__coloringWrapper.visible = true;
		}
		
		public function onAvatarMouseDown(event:flash.events.Event):void
		{
			// the uiActive flag is necessary to stop propagation to device TOUCH events
			uiActive = true;
		}
		
		public function onAvatarMouseOut(event:flash.events.Event):void
		{
			// the uiActive flag is necessary to stop propagation to device TOUCH events
			uiActive = false;
		}
		
		public function onAvatarMouseUp(event:flash.events.Event):void
		{

			// stop propagation works for MOUSE events
			// the uiActive flag is necessary to handle device TOUCH events
			uiActive = false;

			__ColoringMenuController.show(false);
			__coloringWrapper.visible = false;
		}
		
		private function movePage(delta:Point):void 
		{
			var cur_x:int = Math.floor(__coloringWrapper.x + (delta.x * __coloringWrapper.scaleX));
			var cur_y:int = Math.floor(__coloringWrapper.y + (delta.y * __coloringWrapper.scaleX));

			//MAGIC NUMBER
			var min_x:int = (960 + __coloringWrapperOffsetX) - __coloringWrapper.width;
			var min_y:int = 640 - __coloringWrapper.height;
			
			cur_x = Math.max(cur_x, min_x);
			cur_y = Math.max(cur_y, min_y);
			cur_x = Math.min(cur_x, 0 + __coloringWrapperOffsetX);
			cur_y = Math.min(cur_y, 0);
			
			__coloringWrapper.x = cur_x;
			__coloringWrapper.y = cur_y;
				
		}
        
        private function onTouch(event:TouchEvent):void
        {
            // touching the canvas will draw a brush texture. The 'drawBundled' method is not
            // strictly necessary, but it's faster when you are drawing with several fingers
            // simultaneously.
			
			var delta:Point;
			
			__drawingEvent = event;
			var touches:Vector.<Touch> = __drawingEvent.getTouches(__coloringWrapper);
			
			//DECOUPLED if (!uiActive && !WwAlertsManager.instance.alertActive)
			if (!uiActive)
			{
				if (touches.length == 3)
	            {
					// one finger touching -> move
	                delta = touches[0].getMovement(__coloringWrapper);
					movePage(delta);
	            }            
	            else if (touches.length == 1)
	            {
					mRenderTexture.drawBundled(drawWithTouches);
				}
				else if (touches.length == 2)
	            {
	                // two fingers touching -> rotate and scale
	                var touchA:Touch = touches[0];
	                var touchB:Touch = touches[1];
	                
	                var currentPosA:Point  = touchA.getLocation(__coloringWrapper);
	                var previousPosA:Point = touchA.getPreviousLocation(__coloringWrapper);
	                var currentPosB:Point  = touchB.getLocation(__coloringWrapper);
	                var previousPosB:Point = touchB.getPreviousLocation(__coloringWrapper);
	                var currentVector:Point  = currentPosA.subtract(currentPosB);
	                var previousVector:Point = previousPosA.subtract(previousPosB);
	                
	
	                // scale
	                var sizeDiff:Number = currentVector.length / previousVector.length;
	                __coloringWrapper.scaleX *= sizeDiff;
	                __coloringWrapper.scaleY *= sizeDiff;
					
					__coloringWrapper.scaleX = Math.min(__coloringWrapper.scaleX, 3);
					__coloringWrapper.scaleX = Math.max(__coloringWrapper.scaleX, 1);
					
					__coloringWrapper.scaleY = Math.min(__coloringWrapper.scaleY, 3);
					__coloringWrapper.scaleY = Math.max(__coloringWrapper.scaleY, 1);
					
					mBrush.brushScale = 1.0 / __coloringWrapper.scaleX;
					mBrush.brushScale = 1.0 / __coloringWrapper.scaleY;
					
					delta = touches[0].getMovement(__coloringWrapper);
					movePage(delta);
	            }
			}
        }     
        
		
		public function drawWithTouches():void
		{
			var touches:Vector.<Touch> = __drawingEvent.getTouches(__coloringWrapper);
			
			for each (var touch:Touch in touches)
			{
				
				if (touch.phase == TouchPhase.BEGAN)
				{
					__expandscale = 0;
				
				}	
					
				if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.ENDED)
					continue;
				
				var location:Point = touch.getLocation(__coloringWrapper);
				if (mBrush != null)
				{
					
					switch(__blendmode)
					{
						case "erase": mBrush.image.blendMode = BlendMode.ERASE;
						break;
						
						case "normal": mBrush.image.blendMode = BlendMode.NORMAL;
						break;
						
						default: mBrush.image.blendMode = BlendMode.NORMAL;
						break;
					}

					mBrush.image.x = location.x;
					mBrush.image.y = location.y;
					
					switch(__brushDynamicColor)
					{
						case "rainbow":
							
						/*** http://krazydad.com/tutorials/makecolors.php ***/
							
							if (mBrush.image.alpha == 1)
							{
							__rainbowvar += (2 * Math.PI) / 30;
							}
							
							__frequency = 1;
							
							/***normal***/
							__amplitude = 255/2;
							__center = 255/2;
							
							/***pastels***/
							//__amplitude = 25;
							//__center = 230;
							
							/***value = Math.sin(frequency*increment+offset)*amplitude + center;***/
							/***value = Math.sin(   __rainbowvar    +offset)*amplitude + center;***/
							
							__red = Math.sin(__frequency * __rainbowvar + __offset1) * __amplitude + __center;
							__green = Math.sin(__frequency * __rainbowvar + __offset2) * __amplitude + __center; 
							__blue = Math.sin(__frequency * __rainbowvar + __offset3) * __amplitude + __center; 
							
							mBrush.image.color = Color.rgb(__red, __green, __blue);
						
						break;
						
						case "random_rainbow":
							
						if (mBrush.image.alpha == 1)
						{
							__colorvar += 1000000;
						}
							mBrush.image.color = __colorvar;
							
						break;
						
						default:
					}
					
					switch (__brushBehavior) 
					{
						case "rotate_random":
							
							mBrush.resetScale();
							
							mBrush.image.rotation = Math.random() * Math.PI * 2.0;
						break;
						
						case "rotate_normal":
						
							mBrush.resetScale();
						
							mBrush.image.rotation +=  1*((2*Math.PI)/360);
						break;
						
						case "rotate_normal20x":
						
							mBrush.resetScale();
						
							mBrush.image.rotation +=  deg2rad(20);
						break;
						
						case "pulse":
						
							mBrush.resetScale();
						
							__scalevar += (Math.PI/20);
						
							mBrush.image.scaleX = (Math.sin(__scalevar)+2)/4;
							mBrush.image.scaleY = (Math.sin(__scalevar)+2)/4;
						break;
						
						case "dash":
						
							mBrush.resetScale();
						
							mBrush.image.rotation = Math.atan2(__prevy-location.y,__prevx-location.x)-(Math.PI/2)
						
							__prevx = location.x;
							__prevy = location.y;
						break;
					
				
						
					case "interval_dash":
						
						mBrush.resetScale();
					
						__dashinterval = 6;
						
						mBrush.image.rotation = Math.atan2(__prevy-location.y,__prevx-location.x)-(Math.PI/2)
					
						if (__dashvar > 0) { __dashvar--; }
						if (__dashvar == 0) 
							{
								__prevx = location.x;
								__prevy = location.y;
								mBrush.image.alpha = 1;
								__dashvar = __dashinterval; 
							}
						else { mBrush.image.alpha = 0; }
					
					break;
					
				case "interval_dash_2step":
						
						mBrush.resetScale();
						__dashinterval2 = 10;
						
						mBrush.image.rotation = Math.atan2(__prevy-location.y,__prevx-location.x)-(Math.PI/2)
					
						if (__dashvar2 > 0) { __dashvar2--; }
						if (__dashvar2 == 0) 
							{
								__prevx = location.x;
								__prevy = location.y;
								mBrush.image.alpha = 1;
								__dashvar2 = __dashinterval2; 
							}
						else { mBrush.image.alpha = 0; }
					
					break;
					
					case "expand":
						
						__expandscale += .02;
						mBrush.image.scaleX = __expandscale;
						mBrush.image.scaleY = __expandscale;
				
					default:
						mBrush.resetScale();
				}
				
				
				mRenderTexture.draw(mBrush.image);
			  }
			}
		}
		
		public function set brushColorFromString(hex_color:String):void
		{
			__activeColor =  uint(hex_color);

			if (true)
			{		
				
				switch (hex_color)
				{
					
					case "rainbow":
						__blendmode = "normal";
						__brushDynamicColor = "rainbow";
						
					break;
					
					case "random_rainbow":
						__blendmode = "normal";
						__brushDynamicColor = "random_rainbow";
						
						
					break;
					
					case "erase":
						
						__blendmode = "erase";
						__brushDynamicColor = "";
						
					break;
										
					default: 
						__blendmode = "normal";
						__brushDynamicColor = "";					
						mBrush.setColor(__activeColor);
					break;
				}
			}
		}
		
		public function set brush(brush:WwBrush):void
		{
			__debug.msg("set: brush: " + brush);
			mBrush = brush;
			mBrush.setColor(__activeColor);
		}
		
		public function set page(url:String):void
		{
			__ColoringMenuController.show(false);
			__coloringWrapper.visible = false;
			__debug.msg("set: page: " + url);
			mRenderTexture.clear();
			__coloringPage.loadImage(url);
			__UI_ColoringFrame.gotoAndStop("a");
			__debug.msg("  __coloringPage.x: " + __coloringPage.x);
		}
		
		public function set brushBehavior(s:String):void
		{
			__brushBehavior = s;
		}
        
		
		public function colorsMenuOption(value:String):void
		{
			__debug.msg("colorMenuOption: " + value);
			
			brushColorFromString = value;
		}
		
		public function brushesMenuOption(value:String):void
		{
			__debug.msg("brushMenuOption: " + value);
			
			if ((value != null) && (value != ""))
			{
				var tokens:Array = value.split(",");
				var brush_url:String = tokens[0];
				var brush_behavior:String = tokens[1];
				var _brush:WwBrush = new WwBrush();
				_brush.loadImage(brush_url);
				brush = _brush;
				brushBehavior = brush_behavior;
			}
		}
		
		public function pagesMenuOption(value:String):void
		{
			__debug.msg("pagesMenuOption: " + value);
			
			if ((value != null) && (value != ""))
			{
				page = value;
			}
		}
		
		public function gotoMainMenu():void
		{
			__sceneManager.gotoScene("Main");
		}
		
        public override function dispose():void
        {
			removeChildren();
			removeEventListeners();
			
			WwColoring.appStage.removeEventListener(MouseEvent.MOUSE_UP, onGlobalMouseUp);
			
			__coloringWrapper.removeChildren();
			__coloringWrapper.removeEventListeners();
			__coloringWrapper = null;
			
			__coloringPage.removeEventListeners();
			__coloringPage.removeChildren();
			__coloringPage = null;
			
            mRenderTexture.dispose();
			
			WwSprite.FLASH_STAGE.removeChild(__UI_ColoringMenu);
			WwSprite.FLASH_STAGE.removeChild(__UI_ColoringFrame);
			__UI_ColoringFrame = null;
			__UI_ColoringMenu = null;
			
			__ColoringMenuController.dispose();
			__ColoringMenuController = null;
			
            super.dispose();
        }
		
		public function showColoringPageBitmap(bmd:BitmapData, offset:Point, show:Boolean = true):void
		{
			if (bmd)
			{
				__UI_ColoringPageBitmap.bitmapData = bmd;
			}
			else
			{
				return;
			}
			__UI_ColoringPageBitmap.visible = show;
			
			__UI_ColoringPageBitmap.scaleX = 1.0/WwDeviceInfo.instance.assetScaleFactor;
			__UI_ColoringPageBitmap.scaleY = 1.0/WwDeviceInfo.instance.assetScaleFactor;
			//MAGIC NUMBER
			__UI_ColoringPageBitmap.x = 32;
			__UI_ColoringPageBitmap.y = 64;
		}
		
		public function hideColoringPageBitmap(clear:Boolean=false):void
		{
			__UI_ColoringPageBitmap.visible = false;
			if (clear)
			{
				__UI_ColoringPageBitmap.bitmapData = null;
			}
		}
		
		public function onControlShare(event:Event):void
		{
			
			generateBitmapFromScene();
			
			WwGoViral.instance.postTitle = "Title";
			WwGoViral.instance.postCaption = "Caption";
			WwGoViral.instance.postMessage = "Message";
			WwGoViral.instance.postDescription = "Description";
			WwGoViral.instance.postURL = "URL";
			WwGoViral.instance.postImageURL = "ImageURL";
			//WwGoViral.instance.postName = "Name";
			WwGoViral.instance.postEmailSubject = "Subject";
			WwGoViral.instance.postEmailAddresses = "";
			WwGoViral.instance.postEmailBody = "Body";
			//WwGoViral.instance.twitterMessage = "Twitter Message";
			WwAlertsManager.instance.MM_Share();
			
			WwAlertsManager.instance.AV_Share(onShareCompleted);
		}
		
		public function onShareCompleted():void
		{
			
		}
		
		private function generateBitmapFromScene():void
		{		
			var stage:Stage = Starling.current.stage;
			var stage_width:Number = WwDeviceInfo.instance.stageWidth; //stage.stageWidth;
			var stage_height:Number = WwDeviceInfo.instance.stageHeight; //stage.stageHeight;
			var rs:RenderSupport = new RenderSupport();
			__debug.msg("Coloring: generateBitmapFromScene: stageWidth: " + stage_width + ", stageHeight: " + stage_height + ", scaleFactor: " + WwDeviceInfo.instance.assetScaleFactor, "1");
			
			var bmd1_size:Point = new Point(stage_width, stage_height);
			var bmd1:BitmapData = new BitmapData(bmd1_size.x, bmd1_size.y, false, 0xAABBCC);
			__debug.msg("  bmd1_size.x: " + bmd1_size.x + ", bmd1_size.y: " + bmd1_size.y, "1");
			
			var rs_scale:Number = 1.0;
			var scaled_stage_width:Number = stage_width * rs_scale;
			var scaled_stage_height:Number = stage_height * rs_scale;
			rs.clear(stage.color, 1.0);
			rs.scaleMatrix(rs_scale, rs_scale);
			rs.setOrthographicProjection(0, 0, scaled_stage_width, scaled_stage_height);
			
			__debug.msg("  rs_scale: " + rs_scale + ", scaled_stage_width: " + scaled_stage_width + ", scaled_stage_height: " + scaled_stage_height, "1");
			
			stage.render(rs, 1.0);
			rs.finishQuadBatch();
			
			Starling.context.drawToBitmapData(bmd1);
			
			//MAGIC NUMBER - bitmap is always 960x640, for now
			var bmd2_size:Point = new Point(960 * WwDeviceInfo.instance.assetScaleFactor, 640 * WwDeviceInfo.instance.assetScaleFactor);
			var bmd2:BitmapData = new BitmapData(bmd2_size.x, bmd2_size.y, false, 0xCC5577);
			var bmd2_offset:Point = new Point((bmd2_size.x - bmd1_size.x)/2, (bmd2_size.y - bmd1_size.y)/2);
			var mat:Matrix = new Matrix();
			mat.scale(1.0, 1.0);
			mat.translate( bmd2_offset.x, bmd2_offset.y);
			
			__debug.msg("  bmd2_offset.x: " + bmd2_offset.x + ", bmd2_offset.y: " + bmd2_offset.y , "1");
			
			bmd2.draw(bmd1, mat);
			
			showColoringPageBitmap(bmd2, bmd2_offset);
			
			__UI_ColoringFrame.visible = true;
			__UI_ColoringFrame.logo.visible = true;
			__UI_ColoringMenu.visible = false;
			
			//MAGIC NUMBER
			WwGoViral.instance.photoBitmapData = new BitmapData(1024,768);
			WwGoViral.instance.photoBitmapData.draw(WwSprite.FLASH_STAGE);
			
			hideColoringPageBitmap(true);
			
			__UI_ColoringFrame.visible = true;
			__UI_ColoringFrame.logo.visible = false;
			__UI_ColoringMenu.visible = true;			
		}

		public function get uiActive():Boolean
		{
			return __uiActive;
		}

		public function set uiActive(value:Boolean):void
		{
			__uiActive = value;
		}

    }
}