/*
 CodePeek - Copyright(c) 2007 FutureScale, Inc., All rights reserved.
 */
package org.puremvc.as3.demos.air.codepeek.view
{
	import flash.geom.Point;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import mx.controls.Image;
	import mx.styles.StyleManager;
	import mx.managers.PopUpManager;
	import mx.collections.XMLListCollection;

	import org.puremvc.interfaces.*;
	import org.puremvc.patterns.mediator.Mediator;

	import org.puremvc.as3.demos.air.codepeek.view.components.*;
	import org.puremvc.as3.demos.air.codepeek.ApplicationFacade;
	import org.puremvc.as3.demos.air.codepeek.model.CodeSearchProxy;
	import org.puremvc.as3.demos.air.codepeek.model.SearchesProxy;
	
	/**
	 * A Mediator for interacting with the top level Application.
	 * 
	 * <P>
	 * In addition to the ordinary responsibilities of a mediator
	 * the MXML application (in this case) built all the view components
	 * and so has a direct reference to them internally. Therefore
	 * we create and register the mediators for each view component
	 * with an associated mediator here.</P>
	 * 
	 * <P>
	 * Then, ongoing responsibilities are: 
	 * <UL>
	 * <LI>listening for events from the viewComponent (the application)</LI>
	 * <LI>sending notifications on behalf of or as a result of these 
	 * events or other notifications.</LI>
	 * <LI>direct manipulating of the viewComponent by method invocation
	 * or property setting</LI>
	 * </UL>
	 */
	public class ApplicationMediator extends Mediator implements IMediator
	{
		// Cannonical name of the Mediator
		public static const NAME:String = 'ApplicationMediator';
		
		/**
		 * Constructor. 
		 * 
		 * <P>
		 * On <code>applicationComplete</code> in the <code>Application</code>,
		 * the <code>ApplicationFacade</code> is initialized and the 
		 * <code>ApplicationMediator</code> is created and registered.</P>
		 * 
		 * <P>
		 * The <code>ApplicationMediator</code> constructor also registers the 
		 * Mediators for the view components created by the application.</P>
		 * 
		 * @param object the viewComponent (the CodePeek instance in this case)
		 */
		public function ApplicationMediator( viewComponent:Object ) 
		{
			// pass the viewComponent to the superclass where 
			// it will be stored in the inherited viewComponent property
			super( viewComponent );

			// Create and register Mediators for the Stage and
			// components that were instantiated by the mxml application
			facade.registerMediator( new StageMediator( app.stage ) );	
			facade.registerMediator( new AppControlBarMediator( app.controlBar ) );	
			
			// retrieve and cache a reference to frequently accessed proxys
			searchesProxy = SearchesProxy( facade.retrieveProxy( SearchesProxy.NAME ) );
			
			// set the available searchTypes ( as returned by the searchesProxy )
			// as the dataprovider for the application's tree subcomponent
			app.tree.dataProvider = searchesProxy.searchTypes;
			
			// Listen for events from the view component 
			app.addEventListener( CodePeek.TREE_ITEM_SELECTED, onTreeItemSelect );

		}


		/**
		 * Get the Mediator name.
		 * <P>
		 * Called by the framework to get the name of this
		 * mediator. If there is only one instance, we may
		 * define it in a constant and return it here. If
		 * there are multiple instances, this method must
		 * return the unique name of this instance.</P>
		 * 
		 * @return String the Mediator name
		 */
		override public function getMediatorName():String
		{
			return ApplicationMediator.NAME;
		}
		
		/**
		 * List all notifications this Mediator is interested in.
		 * <P>
		 * Automatically called by the framework when the mediator
		 * is registered with the view.</P>
		 * 
		 * @return Array the list of Nofitication names
		 */
		override public function listNotificationInterests():Array 
		{
			
			return [ ApplicationFacade.VIEW_SHOW_WINDOW,
					 ApplicationFacade.CODE_SEARCH_SUCCESS 
				   ];
		}

		/**
		 * Handle all notifications this Mediator is interested in.
		 * <P>
		 * Called by the framework when a notification is sent that
		 * this mediator expressed an interest in when registered
		 * (see <code>listNotificationInterests</code>.</P>
		 * 
		 * @param INotification a notification 
		 */
		override public function handleNotification( note:INotification ):void 
		{
			switch ( note.getName() ) {
				
				// Time to show the application window
				case ApplicationFacade.VIEW_SHOW_WINDOW:
					app.showControls = true;
					break;

				// The code search has returned success
				case ApplicationFacade.CODE_SEARCH_SUCCESS:
					// Reset the tree, open the proper folder 
					// and select the proper item				
					app.tree.dataProvider = searchesProxy.searchTypes;
					app.tree.validateNow();
					var details:Array = note.getBody() as Array;
					var searchType:XMLList = details[0];
					var search:XMLList = details[1];
					app.browser.location = search.@url;
					app.tree.selectedItem = searchType;
					app.tree.expandItem(app.tree.selectedItem, true);
					app.tree.selectedItem = search;
					break;
			}
		}

		/**
		 * An item has been selected in the tree.
		 * 
		 * <P>
		 * An event was dispatched from the application 
		 * and we are handling it here.</P>
		 * <P>
		 * Depending upon whether a language (folder) or 
		 * specific search (document icon) was clicked, 
		 * send notification SEARCH_TYPE_SELECTED or
		 * SEARCH_SELECTED.</P>
		 * <P>
		 * In both cases, we are sending data along with 
		 * the notification. Specifically, an anonymous 
		 * array containing the selected item in the tree 
		 * and its parent, if one exists.</P>
		 * <P>
		 * That would be a search type or a specific 
		 * search.</P>
		 * <P> 
		 * Note that <code>sendNotification</code> is 
		 * inherited from <code>AbstractMediator</code> 
		 * making it easier for all mediators to send 
		 * notifications.</P>
		 * 
		 * @param event the event dispatched by the view component
		 */
		protected function onTreeItemSelect( event:Event ):void
		{
			if ( app.tree.selectedItem.@url == undefined ) {	
				sendNotification( ApplicationFacade.SEARCH_TYPE_SELECTED, app.tree.selectedItem );
			} else {
				sendNotification( ApplicationFacade.SEARCH_SELECTED,[ app.tree.getParentItem( app.tree.selectedItem ), app.tree.selectedItem ] );
				app.browser.location = app.tree.selectedItem.@url;
				
			}
		}

		/**
		 * Cast the viewComponent to its actual type.
		 * 
		 * <P>
		 * This is a useful idiom for mediators. The
		 * PureMVC Mediator class defines a viewComponent
		 * property of type Object. </P>
		 * 
		 * <P>
		 * Here, we cast the generic viewComponent to 
		 * its actual type in a protected mode. This 
		 * retains encapsulation, while allowing the instance
		 * (and subclassed instance) access to a 
		 * strongly typed reference with a meaningful
		 * name.</P>
		 * 
		 * @return app the viewComponent cast to org.puremvc.as3.demos.air.CodePeek
		 */
		protected function get app():CodePeek{
			return viewComponent as CodePeek;
		}

		// Cached reference to search proxy
		private var searchesProxy:SearchesProxy;
	}
}