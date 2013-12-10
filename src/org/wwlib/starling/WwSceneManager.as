package org.wwlib.starling 
{
	import flash.display.Bitmap;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sensors.Accelerometer;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.wwlib.flash.WwAppBG;
	import org.wwlib.flash.WwAudioManager;
	import org.wwlib.utils.WwDebug;
	import org.wwlib.utils.WwDeviceInfo;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwSceneManager extends starling.display.Sprite
	{
		/** Singleton instance */
		private static var __instance:WwSceneManager;
		private var __debug:WwDebug;
		
		private var __bg:WwSprite;
		private var __sceneXmlURL:String = "assets/Config.xml";
		private var __xml:XML;
		private var __sceneXMLList:XMLList;
		private var __appSprite:starling.display.Sprite;
		//private var __MainMenu:Sprite;
        private var __CurrentScene:WwScene;
		private var __sceneDictionary:Dictionary = new Dictionary();
		
		private var __accelerometer:Accelerometer;
		private var __frameTime:int;
		
		//Dependencies
		private var __dependency_WwColoringScene:WwColoringScene;
		private var __dependency_WwScene:WwScene;
		//DECOUPLED private var __dependency_WwStoryScene:WwStoryScene;
		//DECOUPLED private var __dependency_WwSetupScene:WwSetupScene;
		//DECOUPLED private var __dependency_WwSongScene:WwSongScene;
		private var __dependency_WwMainMenuScene:WwMainMenuScene;
		private var __dependency_WwLogosScene:WwLogosScene;
		
		/**
		*   Construct the WwSceneManager. This class is a Singleton, so it should not
		*   be directly instantiated. Instead, call the static "instance" getter
		*   to get an instance of it.
		*   @param enforcer A SingletonEnforcer specifically designed to be
		*                   impossible to pass by outside classes.
		*/
		public function WwSceneManager(enforcer:SingletonEnforcer)
		{
			if (!(enforcer is SingletonEnforcer))
			{
				throw new ArgumentError("WwSceneManager cannot be directly instantiated!");
			}
			
			__debug = WwDebug.instance;
			
			__accelerometer = new Accelerometer();
			__accelerometer.addEventListener(AccelerometerEvent.UPDATE, accelerometerUpdateHandler);
			
			__frameTime = 0;
		}
		
		public function enterFrameUpdateHandler(frame_time:int, total_seconds:Number):void
		{
			if (__CurrentScene)
			{
				__frameTime = frame_time;
				__CurrentScene.enterframeEvent(__frameTime, total_seconds);
			}
		}
		
		public function accelerometerUpdateHandler(event:AccelerometerEvent):void
		{
			if (__CurrentScene)
			{
				__CurrentScene.acceleromterEvent(event);
			}
		}
		
		/**
		*   Initialize the singleton if it has not already been initialized
		*   @return The singleton instance
		*/
		public static function init(app:starling.display.Sprite): WwSceneManager
		{
			if (__instance == null)
			{
				__instance = new WwSceneManager(new SingletonEnforcer());
			}
			
			__instance.__appSprite = app;
			__instance.setup();
			
			return __instance;
		}
		
		private function setup():void
		{
			addEventListener(WwScene.CLOSING, onSceneClosing);
		}
		
		/**
		*   Get the singleton instance
		*   @return The singleton instance or null if it has not yet been
		*           initialized
		*/
		public static function get instance(): WwSceneManager
		{
			return __instance;
		}
		
		public function loadXML():void
		{
			
			// load the xml file using the URLLoader class
			var loader:URLLoader = new URLLoader(new URLRequest(__sceneXmlURL))
			// call xmlLoaded function once the xml has loaded
			loader.addEventListener(flash.events.Event.COMPLETE, xmlLoaded);
		}
		
		private function xmlLoaded(e:flash.events.Event):void {
			// assign loaded xml structure to our xml object
			__xml = new XML(e.target.data);
			__xml.ignoreWhitespace = true;
			
			__bg = new WwSprite();
			__bg.loadImage(__xml.@img_bg);
			__bg.x = WwDeviceInfo.instance.stageX;
			__bg.y = WwDeviceInfo.instance.stageY;
			addChild(__bg);
			
			initscenesWithXML(__xml);
		}
		
		private function initscenesWithXML(xml:XML):void
		{	
			__sceneXMLList = xml.scene;
			var scene_xml:XML;
			var tab_xml:XML;
			var options_xmlList:XMLList;
			//var buttonTexture:Texture = Assets.getTexture("ButtonBig");
            var count:int = 0;
			for each (scene_xml in __sceneXMLList)
			{
				tab_xml = scene_xml.tab[0];
				options_xmlList = scene_xml.option;
				var scene_id:String = scene_xml.@id;
				__debug.msg("Scene: " + scene_id);
				
				__sceneDictionary[scene_id] = scene_xml;
				
				if (scene_xml.@type == "title")
				{
					showScene(scene_id);
				}
				++count;
			}
			WwAppBG.hide();
		}
		
        private function onButtonTriggered(event:starling.events.Event):void
        {
            var button:Button = event.target as Button;
            showScene(button.name);
        }
        
        private function onSceneClosing(event:starling.events.Event):void
        {
            __CurrentScene.removeFromParent(true);
            __CurrentScene = null;
        }
        
        private function showScene(name:String):void
        {
			WwAudioManager.stopCurrentSound();
            if (__CurrentScene)
			{
				__CurrentScene.removeFromParent(true);  //calls dispose()
				__CurrentScene = null;
				System.gc();
				__debug.msg("ShowScene: totalMemory: " + System.totalMemory, "2");
			}
            __debug.msg("showScene: " + name);
			
			var sceneXML:XML = __sceneDictionary[name];
			if (sceneXML == null)
			{
				__debug.msg("showScene:__sceneDictionary[" + name + "] is null");
			}
			else
			{
				var sceneClass:Class = getDefinitionByName(sceneXML.@class_name) as Class;
				__debug.msg("showScene:sceneXML.@class_name: " + sceneXML.@class_name);
				__CurrentScene = new sceneClass(this) as WwScene;
				__debug.msg("__CurrentScene: " + __CurrentScene);
				__CurrentScene.initWithXML(sceneXML);
				__CurrentScene.x = WwDeviceInfo.instance.canvasX + (WwDeviceInfo.instance.assetScaleFactor * sceneXML.@x);
				__CurrentScene.y = WwDeviceInfo.instance.canvasY + (WwDeviceInfo.instance.assetScaleFactor * sceneXML.@y);
				addChild(__CurrentScene);
				
				//__CurrentScene.stage.color = 0xFFFFFF;
			}
        }
		
		public function gotoScene(scene:String):void
		{
			__debug.msg("gotoScene: " + scene);
			showScene(scene);
			
		}
	}
}

/** A class that is here specifically to stop public instantiation of the
*   WwSceneManager singleton. It is inaccessible by classes outside this file. */
class SingletonEnforcer{}
