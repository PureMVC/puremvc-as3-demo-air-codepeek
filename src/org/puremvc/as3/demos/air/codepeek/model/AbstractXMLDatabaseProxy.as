/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.model
{
	import flash.filesystem.File
	import flash.filesystem.FileMode
	import flash.filesystem.FileStream;

	import org.puremvc.interfaces.*;
	import org.puremvc.patterns.proxy.Proxy;
	
	/**
	 * AbstractProxy subclass for handling File I/O for 
	 * an Apoll-based XML database file.
	 * <P>
	 * 
	 */
	public class AbstractXMLDatabaseProxy extends Proxy implements IProxy 
	{

		/**
		 * Constructor. 
		 */
		public function AbstractXMLDatabaseProxy( proxyName:String=null, data:Object=null ) {
			super( proxyName, data );	
		}
		
		/**
		 * Save the in memory XML Database to disk.
		 */
		public function persist():void
		{
			writeXMLDatabase();
		}
		
		/**
		 * Initialize the XML database.
		 * 
		 * <P>Readthe file if it exists, or create one from scratch</P>
		 * <P>This is called from the concrete subclass's constructor. </P>
		 */
		protected function initXMLDatabase( dbName:String, location:File ):void
		{
			// Determine the database file location 	
			this.dbName = dbName;		
			dbFile = location.resolvePath( dbName );
			
			// Read or create the database
			if (dbFile.exists) 	{
				data = readXMLDatabase(); 
			} else {
				data = buildXMLDatabase();
				writeXMLDatabase();
			}
			
			// Parse XML Database
			parseXMLDatabase();
			
		}

		/**
		 * Read the XML Database
		 * 
		 * @return XML the in memory representation of the XML
		 */
		protected function readXMLDatabase():XML
		{
			// Read the database file into an XML object and return it
			var dbStream:FileStream;
			dbStream = new FileStream();
			dbStream.open(dbFile,FileMode.READ);
			var dbXML:XML = XML(dbStream.readUTFBytes(dbStream.bytesAvailable));
			dbStream.close();
			return dbXML;
		}
	
		/**
		 * Write the XML Database to disk.
		 */
		protected function writeXMLDatabase():void
		{
			// Get the string representation of the XML database
			var dbOut:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			dbOut += data.toString();
			dbOut = dbOut.replace(/\n/g, File.lineEnding);
			
			// Write and close the file
			var dbStream:FileStream = new FileStream();
			dbStream.open(dbFile,FileMode.WRITE);
			dbStream.writeUTFBytes(dbOut);
			dbStream.close();
		}

		/**
		 * Build a blank XML database. 
		 * 
		 * <P>
		 * Override in subclass to return a skeleton database.</P>
		 * 
		 * @return XML a blank XML database
		 */
		protected function buildXMLDatabase():XML
		{
			return new XML();
		}

		/**
		 * Parse the incoming XML database. 
		 * 
		 * <P>
		 * Override in subclass to parse the XML database into separate
		 * Proxies.</P>
		 * 
		 * <P>
		 * Rather than clutter the concrete class with
		 * methods and properties for returning specific
		 * parts of the database, create separate proxies
		 * to tend specific areas of the XML database, 
		 * and give them references to pieces of the
		 * XML document.</P>
		 */
		protected function parseXMLDatabase():void
		{
		}

		/**
		 * Cast the data object to its actual type.
		 * 
		 * <P>
		 * This is a useful idiom for proxies. The
		 * PureMVC Proxy class defines a data
		 * property of type Object. </P>
		 * 
		 * <P>
		 * Here, we cast the generic data property to 
		 * its actual type in a protected mode. This 
		 * retains encapsulation, while allowing the instance
		 * (and subclassed instance) access to a 
		 * strongly typed reference with a meaningful
		 * name.</P>
		 * 
		 * @return xml the data property cast to XML
		 */
		protected function get xml():XML 
		{
			return data as XML;
		}

		// the data file reference
		protected var dbFile:File;
		// The data file name
		protected var dbName:String;
		
	}
}