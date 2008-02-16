/*
  CodePeek - Google Code Search for Adobe RIA Developers
  Copyright(c) 2007-08 Cliff Hall <clifford.hall@puremvc.org>
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.demos.air.codepeek.controller
{

	import org.puremvc.as3.demos.air.codepeek.*;
	import org.puremvc.as3.demos.air.codepeek.model.*;
	import org.puremvc.as3.demos.air.codepeek.view.*;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.observer.*;
	import org.puremvc.as3.utilities.air.desktopcitizen.DesktopCitizenConstants;
	
	/**
	 * Create and register <code>Proxy</code>s with the <code>Model</code>.
	 */
	public class StartupCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void	{
			
			var app:CodePeek = note.getBody() as CodePeek;
			
			facade.registerProxy(new CodeSearchProxy());
			facade.registerProxy(new CodePeekDataProxy());
			
			facade.registerMediator( new ApplicationMediator( app ) );
			sendNotification( DesktopCitizenConstants.WINDOW_OPEN, app.stage ); 
		}
	}
}