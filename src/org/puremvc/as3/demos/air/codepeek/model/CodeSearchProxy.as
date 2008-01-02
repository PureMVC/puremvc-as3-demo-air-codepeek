/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.model
{
	import mx.rpc.http.HTTPService;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.collections.XMLListCollection;

	import org.puremvc.interfaces.*;
	import org.puremvc.patterns.proxy.Proxy;
	
	import org.puremvc.as3.demos.air.codepeek.ApplicationFacade;
	
	/**
	 * A Proxy for Google Code Search.
	 */
	public class CodeSearchProxy extends Proxy implements IProxy
	{
		// Canonical Proxy Name
		public static const NAME:String = 'CodeSearchProxy';

		public var searchOptions:Array;
		public var query:String;
		public var option:String;
			
		/**
		 * Constructor.
		 * 
		 * <P>
		 * Create a new HTTPService, prepared to make a request to Google Code.
		 * Also define the search options.</P>
		 */
		public function CodeSearchProxy( data:Object=null ) 
		{
			super ( NAME, data );
			
			codeService=new HTTPService();
	    	codeService.method="POST";
	    	codeService.resultFormat="e4x";
	    	codeService.contentType="application/atom+xml";
	    	codeService.addEventListener( ResultEvent.RESULT, onServiceResult );
	    	codeService.addEventListener( FaultEvent.FAULT, onServiceFault );
	    	
	    	searchOptions = [ {label:ANY_OPTION, 		value:''},
	    			    	  {label:AS_MXML_OPTION, 	value:'file:\\.(as|mxml)$'},
	    					  {label:JAVA_OPTION, 		value:'file:\\.(java|jsp)$'},
	    					  {label:CF_OPTION, 		value:'file:\\.(cfm|cfml|cfc|jsp)$'},
	    					  {label:JS_OPTION, 		value:'file:\\.(js)$'},
   					   		  {label:CSS_OPTION, 		value:'file:\\.(css)$'}
	    					];
		}

		/**
		 * Initiate the Code Search.
		 * 
		 * @param query the query string
		 * @param option the search option
		 */		
		public function search( query:String, option:Object ):void
		{
			data = null;
			this.query = query;
			this.option = option.label;
			codeService.url = CODE_SEARCH_URL + option.value + " " + query;
			codeService.send();			
		}		
		
		/**
		 * Cancel the Code Search.
		 */		
		public function cancel( ):void
		{
			codeService.cancel();			
		}		
		
		/**
		 * Handle Code Search result.
		 * 
		 * @param event the ResultEvent dispatched by the service
		 */
		private function onServiceResult( event:ResultEvent ):void
		{
			data = event.result;
			default xml namespace = atom;
			var success:Boolean = false;
			var searchType:XMLList;
			var search:XMLList;
			var searchesProxy:SearchesProxy = SearchesProxy( facade.retrieveProxy( SearchesProxy.NAME ) );
			try {
				searchType = searchesProxy.getSearchType( option );
				search = searchesProxy.getSearch( searchType, query, feedLink );
				success = ( totalResults > 0 );
			} catch (e:Error) {
				data = null;
				query = null;
				option = null;
				success = false;				
			}		

			if ( success ) {
				sendNotification( ApplicationFacade.CODE_SEARCH_SUCCESS, [ searchType, search ] );
			} else {
				sendNotification( ApplicationFacade.CODE_SEARCH_FAILED );
			}
		}
		
		/**
		 * Decode the given URL.
		 * 
		 * <P>
		 * URLs are returned from the service in escaped format. 
		 * we must unescape them to use them.</P>
		 * 
		 * @param url the URL to decode
		 * @return string the decoded URL
		 */
		private function decodeURL( url:String ):String
		{
			var tmp:String = unescape(url);
			var pattern:RegExp = new RegExp( /\&amp\;/g );
			return tmp.replace( pattern,'&');
		}

		/**
		 * Handle Code Search fault.
		 * 
		 * @param event the FaultEvent
		 */
		private function onServiceFault( event:FaultEvent ):void
		{
			sendNotification(  ApplicationFacade.CODE_SEARCH_FAILED );
		}

		/**
		 * The entries from the current result set.
		 * 
		 * @return XMLList the entries
		 */
		public function get entries():XMLList
		{
			return XMLList( data ).entry as XMLList;
		}

		/** 
		 * The titles from the entries in the current result set.
		 * 
		 * @return XMLList the entry titles
		 */
		public function get titles():XMLList
		{
			default xml namespace = atom;
			return entries.title;
		}
		
		/** 
		 * The feedlink for this search.
		 * 
		 * @return String the feed link for this search
		 */
		public function get feedLink():String
		{
			default xml namespace = atom;
			var link:XMLList = XMLList( data ).link.(@rel == 'alternate') as XMLList;
			return decodeURL(link.@href);
		}
		
		/**
		 * The total number of entries in the current result set.
		 * 
		 * @return Number the total number of results 
		 */
		public function get totalResults():Number
		{
			return ( entries != null )?entries.length():0;
		}		
		
		// The HTTP Service
		private var codeService:HTTPService;

		// Namespaces		
		private static const atom:Namespace 		= new Namespace("http://www.w3.org/2005/Atom");	
		private static const opensearch:Namespace 	= new Namespace("http://a9.com/-/spec/opensearchrss/1.0/");	
		private static const gcs:Namespace 			= new Namespace("http://schemas.google.com/codesearch/2006" );	
		private static const aaa:Namespace 			= new Namespace("http://www.w3.org/XML/1998/namespace");	
		private static const base:Namespace 		= new Namespace("http://www.google.com");	
				
		// The Service Endpoint
		private static const CODE_SEARCH_URL:String 	= "http://www.google.com/codesearch/feeds/search?q=";

		// The Search Options
		private static const ANY_OPTION:String 			= "Any Language";
		private static const AS_MXML_OPTION:String 		= "AS/MXML";
		private static const JAVA_OPTION:String 		= "Java";
		private static const CF_OPTION:String 			= "ColdFusion";
		private static const JS_OPTION:String 			= "JavaScript";
		private static const CSS_OPTION:String 			= "CSS";

	}
}