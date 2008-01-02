/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.model
{
	import flash.filesystem.File
	import flash.filesystem.FileMode
	import flash.filesystem.FileStream;

	import org.puremvc.interfaces.*;

	/** 
	 * Manages the main XML database for CodePeek Preferences
	 * 
	 * <P>
	 * It also implements the <code>IProxy</code> interface allowing it to be
	 * accessed via the Model.</P>
	 * 
	 * @see org.puremvc.as3.demos.air.codepeek.model.AbstractXMLDatabaseProxy AbstractXMLDatabaseProxy
	 */
	public class CodePeekPrefsProxy extends AbstractXMLDatabaseProxy implements IProxy
	{
		public static const NAME:String = 'CodePeekPrefsProxy';
		
		/**
		 * Constructor 
		 * 
		 * <P>
		 * Uses the inherited initXMLDatabase method to read or create
		 * the XML file on disk. If the file does not exist, buildXMLDatabase
		 * will be called. Otherwise, it will be read into the protected
		 * var dbXML.</P>
		 */ 
		public function CodePeekPrefsProxy( ) {
			super( NAME );
			initXMLDatabase( "CodePeekPrefs.xml", File.applicationStorageDirectory );	
		}

		/**
		 * Buld a blank XML Prefs database
		 */
		override protected function buildXMLDatabase():XML
		{
			var dbXML:XML =	
			<CPPreferences xsi:noNamespaceSchemaLocation="http://schemas.futurescale.com/codepeek/v1/CPPreferences.xsd" 
						   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
				<WindowMetrics height="0" width="0" x="0" y="0" display_state="normal"/>
				<SearchOption option=""/>
			</CPPreferences>;
			
			return dbXML;
		}
		
		/**
		 * Parse the XML database into Proxies.  
		 */
		override protected function parseXMLDatabase():void
		{
			facade.registerProxy( new WindowMetricsProxy( xml.WindowMetrics ) );
		}
	}
}