package 
{
    import flash.ui.Keyboard;
    import flash.utils.getTimer;
    
    import org.wwlib.flash.WwAudioManager;
    import org.wwlib.starling.WwSceneManager;
    import org.wwlib.utils.WwDebug;
    
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
    public class Game extends Sprite
    {

		private var __sceneManager:WwSceneManager;
		//DECOUPLED private var __avatarManager:WwAvatarManager;
		private var __prevTime:int;
		private var __frameTime:int;
		private var __totalSeconds:Number;
		private var __frameRate:Number;
		
        public function Game()
        {
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			__prevTime = 0;
			__frameTime = 0;
            
			__sceneManager = WwSceneManager.init(this);
			//DECOUPLED __avatarManager = WwAvatarManager.init();
			addChild(__sceneManager);
			__sceneManager.loadXML();
			
			// ----- Audio Manager
			WwAudioManager.init();
			
        }
        
        private function onAddedToStage(event:Event):void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
        
        private function onRemovedFromStage(event:Event):void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
		
		private function onEnterFrame(event:Event):void
		{
			if (__sceneManager)
			{
				var total_milliseconds:int = getTimer();
				__frameTime = total_milliseconds - __prevTime;
				__prevTime = total_milliseconds;
				__frameRate = 1000.0 / __frameTime;
				__totalSeconds = total_milliseconds / 1000.0;
				__sceneManager.enterFrameUpdateHandler(__frameTime, __totalSeconds);
				//DECOUPLED __avatarManager.enterFrameUpdateHandler(__frameTime, __totalSeconds);
				WwDebug.fps = __frameRate;
			}
		}
        
        private function onKey(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.SPACE)
                Starling.current.showStats = !Starling.current.showStats;
            else if (event.keyCode == Keyboard.X)
                Starling.context.dispose();
        }
    }
}