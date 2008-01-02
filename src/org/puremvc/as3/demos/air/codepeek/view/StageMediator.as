/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.view
{
	import org.puremvc.as3.demos.air.codepeek.ApplicationFacade;
	import org.puremvc.as3.demos.air.codepeek.model.WindowMetricsProxy;
	
	import flash.display.NativeWindowDisplayState;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import org.puremvc.interfaces.*;
	import org.puremvc.patterns.mediator.Mediator;
	
	/**
	 * A Mediator for interacting with the Stage.
	 */
	public class StageMediator extends Mediator implements IMediator
	{
		// Cannonical name of the Mediator
		public static const NAME:String = 'StageMediator';
		// Constant for Minimum stage width
		public static const MIN_WIDTH:Number = 800;
		// Constant for Minimum stage height
		public static const MIN_HEIGHT:Number = 570;
		
		/**
		 * Constructor. 
		 */
		public function StageMediator( viewComponent:Object ) 
		{
			// pass the viewComponent to the superclass where 
			// it will be stored in the inherited viewComponent property
			super( viewComponent );
	
			// cache a reference to frequently used proxies			
			windowMetricsProxy = facade.retrieveProxy( WindowMetricsProxy.NAME ) as WindowMetricsProxy;

			// Listen for events from the view component 
			stage.nativeWindow.addEventListener( Event.CLOSING, onWindowClosing );
			stage.nativeWindow.addEventListener( NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, onFullScreen )
			stage.nativeWindow.addEventListener( NativeWindowBoundsEvent.RESIZE, onResize );
			stage.nativeWindow.addEventListener( NativeWindowBoundsEvent.MOVE, onResize );
			
		}

		/**
		 * Get the Mediator name
		 * <P>
		 * Called by the framework to get the name of this
		 * mediator. If there is only one instance, we may
		 * define it in a constant and return it here. If
		 * there are multiple instances, this method must
		 * return the unique name of this instance.</P>
		 * 
		 * @return String the Mediator name
		 */
		override public function getMediatorName():String
		{
			return StageMediator.NAME;
		}

		/**
		 * List all notifications this Mediator is interested in.
		 * <P>
		 * Automatically called by the framework when the mediator
		 * is registered with the view.</P>
		 * 
		 * @return Array the list of Nofitication names
		 */
		override public function listNotificationInterests():Array 
		{
			return [ ApplicationFacade.VIEW_SET_DEFAULT,
					 ApplicationFacade.VIEW_SET_BOUNDS,
					 ApplicationFacade.VIEW_SET_FULLSCREEN,
					 ApplicationFacade.VIEW_SHOW_WINDOW	 ];
		}

		/**
		 * Handle all notifications this Mediator is interested in.
		 * <P>
		 * Called by the framework when a notification is sent that
		 * this mediator expressed an interest in when registered
		 * (see <code>listNotificationInterests</code>.</P>
		 * 
		 * @param INotification a notification 
		 */
		override public function handleNotification( note:INotification ):void 
		{
			switch ( note.getName() ) {
				
				// The max size of the window was passed in as a Point
				// Set the window size accordingly
				case ApplicationFacade.VIEW_SET_DEFAULT:
					var rect:Rectangle = new Rectangle();
					var maxSize:Point = new Point(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
					rect.width = MIN_WIDTH;
	                rect.height = MIN_HEIGHT;
	                rect.x = (maxSize.x - rect.width)/2;
	                rect.y = (maxSize.y - rect.height)/2;
	                stage.nativeWindow.bounds = rect;
					break;

				// The previously saved window size has been 
				// passed in as a Rectangle. Size the window accordingly
				case ApplicationFacade.VIEW_SET_BOUNDS:
					stage.nativeWindow.bounds = note.getBody() as Rectangle;
					break;

				// Sent when the app was saved in fullscreen mode
				case ApplicationFacade.VIEW_SET_FULLSCREEN:
					stage.nativeWindow.bounds = note.getBody() as Rectangle;
					stage.nativeWindow.maximize();
					break;
					
				// The window has been restored to the saved metrics, now show it 
				// and then notify the application that its show time...
				case ApplicationFacade.VIEW_SHOW_WINDOW:
					stage.nativeWindow.visible = true;
					sendNotification( ApplicationFacade.VIEW_SHOW_CONTROLS );
					break;
			}
		}

		/**
		 * Handle resize event dispatched from the viewComponent.
		 * 
		 * @param event the resize event
		 */
		protected function onResize( event:Event ):void
		{
			//sendNotification( ApplicationFacade.VIEW_RESIZED, stage.window.bounds );
			// The StageMediator passed in a Rectangle representing the size and location
			var rect:Rectangle = stage.nativeWindow.bounds as Rectangle;
			
			// Only save the changes to size and location if not minimized or maximized
			if ( windowMetricsProxy.displayState == NativeWindowDisplayState.NORMAL ) windowMetricsProxy.bounds = rect;
			
			// If this is the result of the window being resized programatically
			// at startup, then it's time to show the window now.
			sendNotification( ApplicationFacade.VIEW_SHOW_WINDOW );
			
		}				
		
		/**
		 * Handle Display State change events dispatched from the viewComponent.
		 * 
		 * @param event the Display State change event
		 */
		protected function onFullScreen( event:NativeWindowDisplayStateEvent ):void
		{
			// Update the WindoMetrics display_state property 
			windowMetricsProxy.displayState = String( event.afterDisplayState );
			
		}				
					
		/**
		 * Handle window closing events dispatched from the viewComponent.
		 * 
		 * @param event the Display State change event
		 */
		protected function onWindowClosing( event:Event ):void
		{
			sendNotification( ApplicationFacade.APP_SHUTDOWN );
		}				
					
		/**
		 * Cast the viewComponent to its actual type.
		 * 
		 * <P>
		 * This is a useful idiom for mediators. The
		 * PureMVC Mediator class defines a viewComponent
		 * property of type Object. </P>
		 * 
		 * <P>
		 * Here, we cast the generic viewComponent to 
		 * its actual type in a protected mode. This 
		 * retains encapsulation, while allowing the instance
		 * (and subclassed instance) access to a 
		 * strongly typed reference with a meaningful
		 * name.</P>
		 * 
		 * @return stage the viewComponent cast to flash.display.Stage
		 */
		protected function get stage():Stage{
			return viewComponent as Stage;
		}

		protected var windowMetricsProxy:WindowMetricsProxy;
	}
}