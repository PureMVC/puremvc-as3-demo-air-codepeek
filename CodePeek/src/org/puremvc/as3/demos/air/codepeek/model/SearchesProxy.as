/*
  CodePeek - Google Code Search for Adobe RIA Developers
  Copyright(c) 2007-08 Cliff Hall <clifford.hall@puremvc.org>
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.demos.air.codepeek.model
{
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.IViewCursor;
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;

	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * A proxy for the Searches data
	 */
	public class SearchesProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'SearchesProxy';

		public function SearchesProxy ( data:Object ) 
		{
			super ( NAME, data );
		}

		/**
		 * Get the specified SearchType from the database,
		 * creating it if necessary.
		 * 
		 * @param type the desired SearchType name
		 * @return XMLList the searchType
		 */
		public function getSearchType( name:String ):XMLList
		{
			var searchType:XMLList = new XMLList( <SearchType name={name}></SearchType>);
			var cursor:IViewCursor = _searchTypesCollection.createCursor();
			var found:Boolean = cursor.findAny( searchType );
			if ( !found ) {
				_searchTypesCollection.disableAutoUpdate();
				if ( searchTypes.length == 0 ) {
					xml..SearchTypes = searchType;
				} else {
					searchTypes.addItem( searchType );
				}
				_searchTypesCollection.enableAutoUpdate();
				_searchTypesCollection.refresh();
			} else {
				searchType = new XMLList( cursor.current );
			}
			return searchType as XMLList;			
		}

		/**
		 * Get the specified Search from the given SearchType,
		 * creating it if necessary.
		 * 
		 * @param type the desired Search name
		 * @return XMLList the search
		 */
		public function getSearch( searchType:XMLList, name:String, link:String ):XMLList
		{
			var searches:XMLListCollection = getSearches( searchType );
			var search:XMLList = new XMLList( <Search name={name} url={link}></Search>);
			var cursor:IViewCursor = searches.createCursor();
			var found:Boolean = cursor.findAny( search );
			if ( !found ) {
				_searchTypesCollection.disableAutoUpdate();
				if ( searches.length == 0 ) {
					searchType..Search = search;
				} else {
					searches.addItem( search );
				}
				_searchTypesCollection.enableAutoUpdate();
				_searchTypesCollection.refresh();
			} else {
				search = new XMLList( cursor.current );
			}
			
			// WTF???? Adobe is inserting cruft into the XML!!!  
			// comment out the following 2 lines to see what 
			// shows up. In the tree it looks like goooglespew,
			// but the debugger shows its a node in namespace 
			// 'mx_internal_uid'. So strip out children of the
			// search node in this namespace before returning...
			namespace mx_internal_uid;
			delete search.children();
			
			return search as XMLList;			
		}
		
		public function getResult( search:XMLList ):XMLList 
		{
			return search;	
		}

		/**
		 * Return the Search elements of the given SearchType as 
		 * a sorted XMLListCollection
		 */
		public function getSearches( searchType:XMLList ):XMLListCollection
		{
			var searches:XMLListCollection = new XMLListCollection( searchType..Search );
			var searchSort:Sort = new Sort();
			searchSort.fields = [ new SortField("@name")];
			searches.sort = searchSort;
			searches.refresh();
			return searches;
		}

		/**
		 * Return the SearchType elements of the data object as 
		 * a sorted XMLListCollection
		 */
		public function get searchTypes():XMLListCollection
		{
			if ( _searchTypesCollection == null ) _searchTypesCollection = new XMLListCollection( xml..SearchType );
			var searchTypeSort:Sort = new Sort();
			searchTypeSort.fields = [ new SortField("@name")];
			_searchTypesCollection.sort = searchTypeSort;
			_searchTypesCollection.refresh();
			return _searchTypesCollection;
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
		 * @return xml the data property cast to XMLList
		 */
		public function get xml():XMLList 
		{
			return data as XMLList;
		}

		// The SearchTypes
		private static var _searchTypesCollection :XMLListCollection;

	}
}