/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.controller
{
	import org.puremvc.patterns.command.*;
	import org.puremvc.interfaces.*;

	/**
	 * A MacroCommand executed when the application exits.
	 *
	 * <P>
	 * Persist the Prefs and Data DBs </P>
	 * 
  	 * @see org.puremvc.as3.demos.air.codepeek.controller.ModelPersistPrefsCommand ModelPersistPrefsCommand
	 */
	public class ApplicationShutdownCommand extends MacroCommand
	{
		
		/**
		 * Initialize the MacroCommand by adding its SubCommands.
		 */
		override protected function initializeMacroCommand() :void
		{
			addSubCommand( org.puremvc.as3.demos.air.codepeek.controller.ModelPersistPrefsCommand );
			addSubCommand( org.puremvc.as3.demos.air.codepeek.controller.ModelPersistDataCommand );
		}
		
	}
}