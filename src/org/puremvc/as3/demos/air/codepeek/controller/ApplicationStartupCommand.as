/*
  CodePeek - Google Code Search for Adobe RIA Developers
  Copyright(c) 2007-08 Cliff Hall <clifford.hall@puremvc.org>
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.demos.air.codepeek.controller
{
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;

	/**
	 * A MacroCommand executed when the application starts.
	 *
  	 * @see org.puremvc.as3.demos.air.codepeek.controller.ModelPrepCommand ModelPrepCommand 
  	 * @see org.puremvc.as3.demos.air.codepeek.controller.ViewPrepCommand ViewPrepCommand 
	 */
	public class ApplicationStartupCommand extends MacroCommand
	{
		
		/**
		 * Initialize the MacroCommand by adding its SubCommands.
		 * 
		 * <P>
		 * Since we built the UI using an MXML <code>Application</code> tag, those
		 * components are created first. The top level <code>Application</code>
		 * then initialized the <code>ApplicationFacade</code>, which in turn initialized 
		 * the <code>Controller</code>, registering Commands. Then the 
		 * <code>Application</code> sent the <code>APP_STARTUP
		 * Notification</code>, leading to this <code>MacroCommand</code>'s execution.</P>
		 * 
		 * <P>
		 * It is important for us to create and register Proxys with the Model 
		 * prior to creating and registering Mediators with the View, since 
		 * availability of Model data is often essential to the proper 
		 * initialization of the View.</P>
		 * 
		 * <P>
		 * So, <code>ApplicationStartupCommand</code> first executes 
		 * <code>ModelPrepCommand</code> followed by <code>ViewPrepCommand</code></P>
		 * 
		 */
		override protected function initializeMacroCommand() :void
		{
			addSubCommand( ModelPrepCommand );
			addSubCommand( ViewPrepCommand );
		}
		
	}
}