/*
  CodePeek - Google Code Search for Adobe RIA Developers
  Copyright(c) 2007-08 Cliff Hall <clifford.hall@puremvc.org>
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.demos.air.codepeek.model
{
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.utilities.air.xmldb.model.XMLDatabaseProxy;

	/** 
	 * Manages the main XML database for CodePeek Preferences
	 * 
	 * <P>
	 * It also implements the <code>IProxy</code> interface allowing it to be
	 * accessed via the Model.</P>
	 * 
	 * @see org.puremvc.as3.utilities.air.xmldb.model.XMLDatabaseProxy XMLDatabaseProxy
	 */
	public class CodePeekPrefsProxy extends XMLDatabaseProxy
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
			initialize( "CodePeekPrefs.xml", File.applicationStorageDirectory );	
		}

		/**
		 * Buld a blank XML Prefs database
		 */
		override protected function build():XML
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
		override protected function parse():void
		{
			facade.registerProxy( new WindowMetricsProxy( xml.WindowMetrics ) );
		}
	}
}