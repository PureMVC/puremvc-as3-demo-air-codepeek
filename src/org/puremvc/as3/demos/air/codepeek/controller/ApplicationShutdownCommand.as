/*
  CodePeek - Google Code Search for Adobe RIA Developers
  Copyright(c) 2007-08 Cliff Hall <clifford.hall@puremvc.org>
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.demos.air.codepeek.controller
{
	import org.puremvc.as3.demos.air.codepeek.model.*;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.utilities.air.xmldb.controller.*;

	/**
	 * Perform final operations when the application exits.
	 *
	 * <P>
	 * Persist the Prefs and Data DBs </P>
	 * 
	 */
	public class ApplicationShutdownCommand extends SimpleCommand
	{
		
		/**
		 * Use the utility's PersistDataCommand to persist both our databases
		 */
		override public function execute( note:INotification ) :void	
		{
			sendNotification( PersistDataCommand.NAME, CodePeekDataProxy.NAME  );
			sendNotification( PersistDataCommand.NAME, CodePeekPrefsProxy.NAME  );
		}
		
	}
}