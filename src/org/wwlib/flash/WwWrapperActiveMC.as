package org.wwlib.flash 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import org.wwlib.utils.WwDebug;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 * 
	 * This wrapper class is necessary because all movie clips in the FLA/SWF have to have the same, MovieClip base class.
	 */
	public class WwWrapperActiveMC
	{
		protected var __debug:WwDebug;
		
		private var __mc:MovieClip;
		private var __id:String;
		private var __startXY:Point;
		private var __targetXY:Point;
		private var __springAmplitudeXY:Point;
		private var __springDampeningXY:Point;
		private var __springFrequency:Number;
		private var __easeing:Number;
		
		public function WwWrapperActiveMC(_mc:MovieClip) 
		{
			__debug = WwDebug.instance;
			
			if (_mc)
			{
				__mc = _mc;
				__debug = WwDebug.instance;
				
				__startXY = new Point(__mc.x, __mc.y);
				__targetXY = new Point(__mc.x, __mc.y);
				__springAmplitudeXY = new Point(0, 0);
				__springDampeningXY = new Point(.95, 0.95);
				__springFrequency = 9;
				__easeing = .1;
			}
			else
			{
				__debug.msg("WwWrapperActive:constructor __mc == null", "3");
			}
		}
		
		private function spring(total_seconds:Number):void
		{
			if (__mc)
			{
				__springAmplitudeXY.y = __springAmplitudeXY.y * __springDampeningXY.y;
				
				var cos_y:Number = Math.cos(total_seconds * 3.14 * __springFrequency) * __springAmplitudeXY.y;
				var new_x:Number = __mc.x + (__targetXY.x - __mc.x) * __easeing;
				var new_y:Number = __mc.y + ((__targetXY.y + cos_y) - __mc.y) * __easeing;
				
				__mc.x = new_x;
				__mc.y = new_y;
			}
			else
			{
				__debug.msg("WwWrapperActive:spring: __mc == null", "3");
			}
		}
		
		public function update(frame_time:int, total_seconds:Number):void
		{
			spring(total_seconds);
		}
		
		public function set springAmplitude(p:Point):void
		{
			__springAmplitudeXY = p;
		}
		
		public function set springDampening(p:Point):void
		{
			__springDampeningXY = p;
		}
		
		public function set springFrequency(f:Number):void
		{
			__springFrequency = f;
		}
		
		public function get id():String
		{
			return __id;
		}
		
		public function set id(id:String):void
		{
			__id = id;
			if (__mc)
			{
				__mc.id = id;
			}
		}
		
		public function get mc():MovieClip
		{
			return __mc;
		}
		
		public function get startXY():Point
		{
			return __startXY
		}
		
		public function set startXY(p:Point):void 
		{
				__startXY = p;
		}
		
		public function get targetXY():Point
		{
			return __targetXY
		}
		
		public function set targetXY(p:Point):void 
		{
				__targetXY = p;
		}
		
		public function dispose():void
		{
			__startXY = null;
			__targetXY = null;
			__springAmplitudeXY = null;
			__springDampeningXY = null;
		}
		
	}

}