/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.controller
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.NativeWindowDisplayState;

	import org.puremvc.interfaces.*;
	import org.puremvc.patterns.command.*;
	import org.puremvc.patterns.observer.*;
	
	import org.puremvc.as3.demos.air.codepeek.*;
	import org.puremvc.as3.demos.air.codepeek.model.*;
	import org.puremvc.as3.demos.air.codepeek.view.ApplicationMediator;
	
	/**
	 * Prepare the View for use.
	 * 
	 * <P>
	 * The <code>Notification</code> was sent by the <code>Application</code>,
	 * and a reference to that view component was passed on the note body.
	 * The <code>ApplicationMediator</code> will be created and registered using this
	 * reference. The <code>ApplicationMediator</code> will then register 
	 * all the <code>Mediator</code>s for the components it created.</P>
	 * 
	 * <P>
	 * Next, the WindowMetrics XML will be retrieved from the <code>PrefsDBProxy</code>
	 * Proxy, and if this is the first time the app is launched, 
	 * we will send out a ViewDefaultBoundsNotification, which 
	 * the StageMediator will respond to by setting the stage 
	 * window to a default size.
	 * 
	 * <P>
	 * If the application has run before, WindowMetrics will be 
	 * converted to a Rectangle object and sent as the body of 
	 * a ViewSetBoundsNotification, which the StageMediator will 
	 * respond to by setting the stage window bounds to the 
	 * Rectangle.</P>
	 */
	public class ViewPrepCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void	{
			
			// Register the ApplicationMediator
			facade.registerMediator( new ApplicationMediator( note.getBody() ) );			
			
			// Get the WindowMetricsProxy
			var windowMetrics:WindowMetricsProxy = facade.retrieveProxy( WindowMetricsProxy.NAME ) as WindowMetricsProxy;
			
			// if this is the first launch of the app, tell the view to set default bounds.
			// otherwise, restore saved bounds or fullscreen state
			if ( windowMetrics.width == 0 ) {
				sendNotification( ApplicationFacade.VIEW_SET_DEFAULT );
			} else {
				if ( windowMetrics.displayState == NativeWindowDisplayState.NORMAL ) 
				{
					sendNotification( ApplicationFacade.VIEW_SET_BOUNDS, windowMetrics.bounds );
				} else {
					sendNotification( ApplicationFacade.VIEW_SET_FULLSCREEN, windowMetrics.bounds );
				}
			}

		}

		
	}
}