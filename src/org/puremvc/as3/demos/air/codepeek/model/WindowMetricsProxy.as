/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.model
{
	import flash.geom.Rectangle;

	import org.puremvc.interfaces.*;
	import org.puremvc.patterns.proxy.Proxy;
	
	/**
	 * A proxy for the WindowMetrics data
	 */
	public class WindowMetricsProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'WindowMetricsProxy';

		public function WindowMetricsProxy( data:Object ) 
		{
			super ( NAME, data );
		}

		// Get the x value from the xml as a Number
		public function get x():Number
		{
			return Number(xml.@x)||0;
		}		
			
		// Get the y value from the xml as a Number
		public function get y():Number
		{
			return Number(xml.@y)||0;
		}
				
		// Get the width value from the xml as a Number	
		public function get width():Number
		{
			return Number(xml.@width)||0;
		}		
		
		// Get the height value from the xml as a Number	
		public function get height():Number
		{
			return Number(xml.@height)||0;
		}		
			
		// Get the display_state value from the xml
		public function get displayState():String
		{
			return xml.@display_state;
		}		

		// Set the display_state value in the xml
		public function set displayState( value:String ):void
		{
			xml.@display_state = value;	
		}

		// Get the bounds from the xml as a Rectangle
		public function get bounds():Rectangle
		{
			var rect:Rectangle = new Rectangle();
			rect.width = width;
			rect.height = height;
			rect.x = x;
			rect.y = y;
			return rect;
		}
		
		// Set the bounds in the xml from a Rectangle
		public function set bounds(rect:Rectangle):void 
		{
			xml.@width  = rect.width;
			xml.@height = rect.height;
			xml.@x = rect.x;
			xml.@y = rect.y;
			
		}
		
		// Get the Proxy data object as an XMLList
		public function get xml():XMLList 
		{
			return data as XMLList;
		}
		
	}
}