/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.controller
{
	import org.puremvc.patterns.command.*;
	import org.puremvc.interfaces.*;
	
	import org.puremvc.as3.demos.air.codepeek.model.*;
	import org.puremvc.as3.demos.air.codepeek.*;
	
	/**
	 * Persist the CodePeekData XML Database
	 */
	public class ModelPersistDataCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void	{
			// Get the CodePeekDataProxy 
			var db:CodePeekDataProxy = facade.retrieveProxy( CodePeekDataProxy.NAME ) as CodePeekDataProxy;
			
			// Persist Database
			db.persist();
			
		}
	}
}