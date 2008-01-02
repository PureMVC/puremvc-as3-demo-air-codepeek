/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.controller
{
	import org.puremvc.patterns.command.*;
	import org.puremvc.interfaces.*;
	
	import org.puremvc.as3.demos.air.codepeek.*;
	import org.puremvc.as3.demos.air.codepeek.model.*;

	/**
	 * Persist the CodePeek Prefs XML Database
	 */
	public class ModelPersistPrefsCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void	{
			// Get the Preferences Proxy
			var prefs:CodePeekPrefsProxy = facade.retrieveProxy( CodePeekPrefsProxy.NAME ) as CodePeekPrefsProxy;
			
			// Persist Preferences DB
			prefs.persist();
			
		}
	}
}