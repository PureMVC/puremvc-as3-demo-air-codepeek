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
	 * Manages the XML database for CodePeek Application data. 
	 * 
	 * <P>
	 * It also implements the <code>IProxy</code> interface allowing it to be
	 * accessed via the Model.</P>
	 * 
	 * @see org.puremvc.as3.utilities.air.xmldb.model.XMLDatabaseProxy XMLDatabaseProxy
	 */
	public class CodePeekDataProxy extends XMLDatabaseProxy
	{
		public static const NAME:String = 'CodePeekDataProxy';
		
		/**
		 * Constructor 
		 * 
		 * <P>
		 * Uses the inherited initXMLDatabase method to read or create
		 * the XML file on disk. If the file does not exist, buildXMLDatabase
		 * will be called. Otherwise, it will be read into the protected
		 * var dbXML.</P>
		 */ 
		public function CodePeekDataProxy( ) {
			super( NAME );
			initialize( "CodePeekData.xml", File.applicationStorageDirectory );
		}

		/**
		 * Build a blank XML Database.
		 * 
		 * <P>
		 * This is called by the <code>AbstractXMLDatabaseProxy</code> 
		 * when it attempts to read the file for the first time
		 * and discovers it doesn't exist.</P>
		 *
		 */
		override protected function build():XML
		{
			// The database structure
			var dbXML:XML =
			<CodePeek/>
						
			// Build an initial Searches block that contains all the 
			// search options defined in the CodeSearchProxy
			var codeSearchProxy:CodeSearchProxy = facade.retrieveProxy( CodeSearchProxy.NAME ) as CodeSearchProxy;
			var searches:XML = <Searches/>;
			for ( var i:int=0; i<codeSearchProxy.searchOptions.length; i++) {
				searches.appendChild(<SearchType name={codeSearchProxy.searchOptions[i].label}/>);
			}
			
			// Add the block to the database structure			
			dbXML.appendChild( searches );

			return dbXML;
		}

		/**
		 * Parse the XML database into Proxies.  
		 */
		override protected function parse():void
		{
			facade.registerProxy( new SearchesProxy( xml.Searches ) );
		}

	}
}