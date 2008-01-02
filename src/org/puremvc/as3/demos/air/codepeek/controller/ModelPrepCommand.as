/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.controller
{

	import org.puremvc.interfaces.*;
	import org.puremvc.patterns.command.*;
	import org.puremvc.patterns.observer.*;
	
	import org.puremvc.as3.demos.air.codepeek.*;
	import org.puremvc.as3.demos.air.codepeek.model.*;
	
	/**
	 * Create and register <code>Proxy</code>s with the <code>Model</code>.
	 */
	public class ModelPrepCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void	{
			
			facade.registerProxy(new CodeSearchProxy());
			facade.registerProxy(new CodePeekPrefsProxy());
			facade.registerProxy(new CodePeekDataProxy());
			
		}
	}
}